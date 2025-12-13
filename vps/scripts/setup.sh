#!/bin/bash

set -euo pipefail

# =========================
# Logging
# =========================
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() { echo; echo -e "${GREEN}[INFO]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }
log_status() { echo -e "${BLUE}[STATUS]${NC} $1"; }

# =========================
# System Update + Packages
# =========================
log_info "Updating system and installing base packages..."
sudo apt update && sudo apt upgrade -y
sudo apt install -y build-essential curl file git gnupg || true

# =========================
# Zsh + Oh My Zsh
# =========================
if ! command -v zsh >/dev/null 2>&1; then
    log_info "Installing Zsh..."
    sudo apt install -y zsh
    log_info "Setting Zsh as the default shell..."
    sudo chsh -s "$(which zsh)" "$USER"
else
    log_info "Zsh is already installed, skipping..."
fi

if [ ! -d "$HOME/.oh-my-zsh" ]; then
    log_info "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    log_info "Oh My Zsh is already installed, skipping..."
fi

ZSH_CUSTOM=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}

log_info "Installing zsh plugins..."
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
    log_info "Installed zsh-autosuggestions plugin"
else
    log_info "zsh-autosuggestions plugin already installed"
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
    log_info "Installed zsh-syntax-highlighting plugin"
else
    log_info "zsh-syntax-highlighting plugin already installed"
fi

# =========================
# NVM + NodeJS
# =========================
if ! command -v nvm >/dev/null 2>&1; then
    log_info "Installing NVM..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
else
    log_info "NVM is already installed, skipping..."
fi

export NVM_DIR="${XDG_CONFIG_HOME:-$HOME/.nvm}"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

if ! command -v node >/dev/null 2>&1; then
    log_info "Installing LTS NodeJS..."
    nvm install --lts
else
    log_info "NodeJS is already installed, skipping..."
fi


# =========================
# PM2, Bun and PNPM
# =========================
log_info "Checking and installing PM2, Bun, and PNPM..."
for pkg in pm2 bun pnpm; do
    if npm list -g --depth=0 "$pkg" >/dev/null 2>&1; then
        log_info "$pkg is already installed globally, skipping..."
    else
        log_info "Installing $pkg globally..."
        npm install -g "$pkg"
    fi
done

# =========================
# .zshrc Setup
# =========================
log_info "Configuring Zsh..."
if [ ! -f ~/.zshrc ] || ! grep -q "nvm.sh" ~/.zshrc; then
    [ -f ~/.zshrc ] && mv -f ~/.zshrc ~/.zshrc.bak
    cat > ~/.zshrc <<'EOF'
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"

plugins=(
  git
  colored-man-pages
  dirhistory
  jsontools
  nvm
  zsh-syntax-highlighting
  zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
EOF
    log_info "Created new ~/.zshrc"
else
    log_info "~/.zshrc already configured, skipping..."
fi

# =========================
# MongoDB Install
# =========================
if ! command -v mongod >/dev/null 2>&1; then
    log_info "Installing MongoDB..."
    MONGO_KEY_VERSION="8.0"
    MONGO_VERSION="8.2"
    UBUNTU_CODENAME=$(lsb_release -sc 2>/dev/null || grep VERSION_CODENAME /etc/os-release | cut -d= -f2)

    curl -fsSL https://www.mongodb.org/static/pgp/server-${MONGO_KEY_VERSION}.asc | \
        sudo gpg -o /usr/share/keyrings/mongodb-server-${MONGO_KEY_VERSION}.gpg \
        --dearmor

    repo_exists() {
        curl --head --silent --fail "https://repo.mongodb.org/apt/ubuntu/dists/$1/mongodb-org/$2/" >/dev/null
    }

    if repo_exists "$UBUNTU_CODENAME" "$MONGO_VERSION"; then
        REPO_CODENAME="$UBUNTU_CODENAME"
    else
        REPO_CODENAME="noble"
    fi

    echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-${MONGO_KEY_VERSION}.gpg ] \
    https://repo.mongodb.org/apt/ubuntu $REPO_CODENAME/mongodb-org/$MONGO_VERSION multiverse" \
    | sudo tee /etc/apt/sources.list.d/mongodb-org-${MONGO_VERSION}.list >/dev/null

    sudo apt update -y
    sudo apt install -y mongodb-org
else
    log_info "MongoDB is already installed, skipping..."
fi

log_info "Ensuring MongoDB is running..."
sudo systemctl enable --now mongod

# =========================
# MongoDB Replication Setup
# =========================
if ! grep -q "replSetName" /etc/mongod.conf; then
    log_info "Configuring MongoDB replication..."
    sudo tee -a /etc/mongod.conf > /dev/null <<EOF

replication:
  replSetName: "rs0"
EOF
    sudo systemctl restart mongod

    until mongosh --quiet --eval "db.adminCommand('ping')" >/dev/null 2>&1; do
        sleep 1
    done

    IS_INITIATED=$(mongosh --quiet --eval 'rs.status().ok' 2>/dev/null || echo 0)
    if [ "$IS_INITIATED" -ne 1 ]; then
        log_info "Initiating replica set..."
        mongosh --quiet --eval "rs.initiate()" >/dev/null 2>&1
    fi
else
    log_info "MongoDB replication already configured, skipping..."
fi

# =========================
# UFW Setup
# =========================
log_info "Configuring UFW firewall..."
sudo ufw enable || log_info "UFW already enabled"
sudo ufw allow ssh
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw reload

# =========================
# Nginx Install
# =========================
if ! command -v nginx >/dev/null 2>&1; then
    log_info "Installing Nginx..."
    sudo apt install -y nginx
else
    log_info "Nginx is already installed, skipping..."
fi

sudo systemctl enable --now nginx

# =========================
# GitHub SSH
# =========================
log_info "Setting up GitHub SSH"
read -p "Enter GitHub Email: " EMAIL

if [ -f ~/.ssh/id_rsa ]; then
    log_info "SSH key already exists, skipping keygen"
else
    ssh-keygen -t rsa -b 4096 -C "$EMAIL" -f ~/.ssh/id_rsa -N ""
    log_info "Created new SSH key"
fi

eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa

# =========================
# Status Checks
# =========================
log_info "Checking final service statuses..."
log_status "MongoDB service: $(systemctl is-active mongod)"
log_status "Nginx service: $(systemctl is-active nginx)"

# =========================
# Version Info
# =========================
echo
log_status "Node version: $(node -v)"
log_status "NPM version: $(npm -v)"
log_status "Zsh version: $(zsh --version)"
log_status "Default shell: $SHELL"
log_status "GitHub SSH Key: "
cat ~/.ssh/id_rsa.pub

log_info "Setup completed successfully!"
log_info "Restart your system for changes to be fully applied!"