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
log_info "Updating system and installing packages..."
sudo apt update && sudo apt upgrade -y
sudo apt install -y build-essential curl file git zsh gnupg

# =========================
# Zsh + Oh My Zsh
# =========================
log_info "Setting Zsh as the default shell..."
sudo chsh -s "$(which zsh)" "$USER"

log_info "Installing Oh My Zsh..."
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

ZSH_CUSTOM=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}

log_info "Installing zsh plugins..."
git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions" || true
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" || true

# =========================
# NVM + NodeJS
# =========================
log_info "Installing NVM..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash

export NVM_DIR="${XDG_CONFIG_HOME:-$HOME/.nvm}"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

log_info "Installing LTS NodeJS..."
nvm install --lts

log_info "Installing PM2, Bun, and PNPM..."
npm install -g pm2 bun pnpm

# =========================
# .zshrc Setup
# =========================
log_info "Configuring Zsh..."
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

source ~/.zshrc

# =========================
# MongoDB Install
# =========================
log_info "Installing MongoDB..."

MONGO_KEY_VERSION="8.0"
MONGO_VERSION="8.2"

UBUNTU_CODENAME=$(
    lsb_release -sc 2>/dev/null || \
    grep VERSION_CODENAME /etc/os-release | cut -d= -f2
)

curl -fsSL https://pgp.mongodb.com/server-${MONGO_KEY_VERSION}.asc \
    | sudo tee /usr/share/keyrings/mongodb-server-${MONGO_KEY_VERSION}.gpg >/dev/null

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

log_info "Starting MongoDB..."
sudo systemctl start mongod
sudo systemctl enable mongod

# =========================
# MongoDB Status Check
# =========================
log_info "Checking MongoDB status..."

if ! systemctl is-active --quiet mongod; then
    log_error "MongoDB service is not active."
    exit 1
fi

if ! ss -tln | grep -q ':27017'; then
    log_error "MongoDB not listening on port 27017."
    exit 1
fi

log_info "MongoDB is fully running."

# =========================
# MongoDB Replication Setup
# =========================
log_info "Configuring MongoDB replication..."

sudo systemctl stop mongod

if ! grep -q "replSetName" /etc/mongod.conf; then
    sudo tee -a /etc/mongod.conf > /dev/null <<EOF

replication:
  replSetName: "rs0"
EOF
fi

sudo systemctl start mongod

# Wait for MongoDB
until mongosh --quiet --eval "db.adminCommand('ping')" >/dev/null 2>&1; do
    sleep 1
done

IS_INITIATED=$(mongosh --quiet --eval 'rs.status().ok' 2>/dev/null || echo 0)

if [ "$IS_INITIATED" -ne 1 ]; then
    log_info "Initiating replica set..."
    mongosh --quiet --eval "rs.initiate()" >/dev/null 2>&1
fi

RS_OK=$(mongosh --quiet --eval 'rs.status().ok' 2>/dev/null || echo 0)

if [ "$RS_OK" -eq 1 ]; then
    log_info "Replica set is healthy."
else
    log_error "Replica set is NOT healthy."
    exit 1
fi

# =========================
# UFW Setup
# =========================
log_info "Configuring UFW firewall..."

sudo ufw enable
sudo ufw allow ssh
sudo ufw reload

# =========================
# Nginx Install
# =========================
log_info "Installing Nginx..."
sudo apt install -y nginx

sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw reload


# =========================
# GitHub SSH
# =========================
log_info "Setting up GitHub SSH"
read -p "Enter GitHub Email: " EMAIL

if [ -f ~/.ssh/id_rsa ]; then
    log_info "SSH key already exists, skipping keygen"
else
    ssh-keygen -t rsa -b 4096 -C "$EMAIL" -f ~/.ssh/id_rsa -N ""
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
