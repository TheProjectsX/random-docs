#!/bin/bash

# ======================
# NGINX + SSL Deployment Script
# ======================

set -euo pipefail

# --- Defaults & Flags ---
DRY_RUN=false
VERBOSE=false
SKIP_UPDATE=false

while [[ $# -gt 0 ]]; do
    case $1 in
        -n|--dry-run) DRY_RUN=true; shift ;;
        -v|--verbose) VERBOSE=true; shift ;;
        -s|--skip-update) SKIP_UPDATE=true; shift ;;
        *) echo "Usage: $0 [-n|--dry-run] [-v|--verbose] [-s|--skip-update]"; exit 1 ;;
    esac
done

# --- Logging Setup ---
LOG_FILE="/var/log/nginx-deploy.log"
exec > >(tee -a "$LOG_FILE") 2>&1

if $VERBOSE; then
    set -x
fi

GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() { printf "\n${GREEN}[INFO]${NC} %s\n" "$1"; }
log_error() { printf "\n${RED}[ERROR]${NC} %s\n" "$1"; }
log_status() { printf "${BLUE}[STATUS]${NC} %s\n" "$1"; }

# --- Ensure Running as Root ---
if [ "$EUID" -ne 0 ]; then
    log_error "Please run as root or via sudo."
    exit 1
fi

# --- Retry-able apt update ---
apt_update() {
    for i in {1..5}; do
        if apt update; then
            return 0
        fi
        sleep 2
    done
    log_error "Failed to update package list after multiple attempts."
    exit 1
}

# --- Check & Install Package ---
install_pkg() {
    local pkg=$1
    if ! dpkg -l | grep -qw "$pkg"; then
        log_info "Installing $pkg..."
        if ! $DRY_RUN; then
            apt install -y "$pkg"
        fi
    else
        log_info "$pkg already installed."
    fi
}

# --- Validate Port Number ---
validate_port() {
    local p=$1
    if ! [[ "$p" =~ ^[0-9]+$ ]] || [ "$p" -lt 1 ] || [ "$p" -gt 65535 ]; then
        return 1
    fi
    return 0
}

# --- Check Free Port ---
check_port_free() {
    local p=$1
    if lsof -i :"$p" | grep -q LISTEN; then
        return 1
    fi
    return 0
}

# --- Check Domain Resolvability (timeout 2s) ---
domain_resolves() {
    local d=$1
    if dig +time=2 +short "$d" | grep -q '\.'; then
        return 0
    fi
    return 1
}

# --- Check Email is Valid ---
is_valid_email() {
    [[ "$1" =~ ^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$ ]]
}


# ===== Main =====
log_info "Starting deployment script..."
if ! $SKIP_UPDATE; then
    apt_update
fi

# --- Install Required Packages ---
for pkg in nginx certbot python3-certbot-nginx ufw dnsutils; do
    install_pkg "$pkg"
done

# --- Verify certbot ---
if ! command -v certbot >/dev/null; then
    log_error "certbot not found after installation."
    exit 1
fi
log_info "certbot is installed: $(certbot --version || true)"

# --- UFW Setup ---
if ufw status | grep -q inactive; then
    log_info "Enabling UFW with restrictive defaults..."
    ufw default deny incoming
    ufw default allow outgoing
    ufw --force enable
fi
log_info "Allowing HTTP/HTTPS through UFW..."
ufw allow 'Nginx Full'

# --- Prompt for Application Port ---
while true; do
    read -p "Enter the port number for your application: " APP_PORT </dev/tty
    if ! validate_port "$APP_PORT"; then
        log_error "Invalid port. Must be 1–65535."
        continue
    fi
    if ! check_port_free "$APP_PORT"; then
        log_error "Port $APP_PORT is in use."
        continue
    fi
    break
done

# --- Prompt for Domain & Email ---
read -p "Enter your domain (e.g. example.com): " DOMAIN </dev/tty
if ! [[ "$DOMAIN" =~ ^([a-zA-Z0-9]([a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?\.)+[a-zA-Z]{2,}$ ]]; then
    log_error "Invalid domain name."
    exit 1
fi

CERTBOT_EMAIL_FILE="/etc/letsencrypt/.certbot_email"
CERTBOT_EMAIL=""

if [ -f "$CERTBOT_EMAIL_FILE" ]; then
    CERTBOT_EMAIL="$(sudo cat "$CERTBOT_EMAIL_FILE" | tr -d '[:space:]')"

    if is_valid_email "$CERTBOT_EMAIL"; then
        log_info "Using stored Certbot email: $CERTBOT_EMAIL"
    else
        log_error "Invalid email found in $CERTBOT_EMAIL_FILE"
        CERTBOT_EMAIL=""
    fi
fi

while ! is_valid_email "$CERTBOT_EMAIL"; do
    read -p "Enter valid email for Let's Encrypt: " CERTBOT_EMAIL </dev/tty
done

# Persist (only once / overwrite invalid)
echo "$CERTBOT_EMAIL" | sudo tee "$CERTBOT_EMAIL_FILE" >/dev/null
sudo chmod 600 "$CERTBOT_EMAIL_FILE"

log_info "Certbot email ready: $CERTBOT_EMAIL"

# --- Paths & Config ---
NGINX_CONF="/etc/nginx/conf.d/${DOMAIN}.conf"

# --- Remove Old Config ---
if [ -f "$NGINX_CONF" ]; then
    log_info "Removing old Nginx config for $DOMAIN..."
    rm -f "$NGINX_CONF"
fi

# --- Write New Config ---
log_info "Creating Nginx config for $DOMAIN → port $APP_PORT"
cat > "$NGINX_CONF" <<EOF
server {
    listen 80;
    server_name $DOMAIN www.$DOMAIN;

    location / {
        proxy_pass http://localhost:$APP_PORT;
        proxy_http_version 1.1;

        # WebSocket support (if needed)
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "upgrade";

        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;

        proxy_cache_bypass \$http_upgrade;
    }
}
EOF

# --- Validate & Reload Nginx ---
log_info "Testing Nginx configuration..."
nginx -t
log_info "Reloading Nginx (graceful)..."
nginx -s reload

# --- Obtain / Renew SSL Certificate ---
if [ ! -d "/etc/letsencrypt/live/$DOMAIN" ]; then
    log_info "Issuing certificate for $DOMAIN..."
    if ! domain_resolves "www.$DOMAIN"; then
		log_info "www.$DOMAIN does not resolve. Issuing for $DOMAIN only."
		certbot --nginx -d "$DOMAIN" --email "$CERTBOT_EMAIL" --non-interactive --agree-tos
	else
		certbot --nginx -d "$DOMAIN" -d "www.$DOMAIN" --non-interactive --agree-tos
	fi
else
    log_info "Certificate exists. Running renewal check..."
    certbot renew --nginx
fi


# --- Setup Renewal Cron Job (if not present) ---
if ! crontab -l | grep -q 'certbot renew'; then
    log_info "Adding daily certbot renew cron job..."
    (crontab -l 2>/dev/null; echo "0 3 * * * certbot renew --quiet") | crontab - || \
        log_error "Failed to add certbot renew cron job, continuing..."
fi

log_info "Deployment complete! Your site is live on https://$DOMAIN"
