#!/bin/bash

set -e  # Exit on any error

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# Logging function with colors
log() {
    local level=$1
    local msg=$2
    case $level in
        "INFO")
            echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')] ${GREEN}INFO${NC}: $msg"
            ;;
        "WARN")
            echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')] ${YELLOW}WARN${NC}: $msg"
            ;;
        "ERROR")
            echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')] ${RED}ERROR${NC}: $msg"
            ;;
    esac
}

# Pretty print section headers
print_section() {
    echo -e "\n${BOLD}${BLUE}=== $1 ===${NC}\n"
}

# Error handling function
handle_error() {
    local line=$1
    local type=$2
    case "$type" in
        nix_install) log "ERROR" "Failed to install Nix. Check https://nixos.org/download.html for requirements." ;;
        channel) log "ERROR" "Failed to add/update channels. Check your internet connection." ;;
        hm_install) log "ERROR" "Failed to install Home Manager." ;;
        apply) log "ERROR" "Failed to apply Home Manager configuration." ;;
        *) log "ERROR" "An unknown error occurred on line $line" ;;
    esac
}

# Set up error trap
trap 'handle_error ${LINENO} ${FUNCNAME:-unknown}' ERR

print_section "Installation Start"

# Check if running in WSL
if ! grep -q microsoft /proc/version; then
    log "WARN" "This script is designed for WSL. Some features might not work as expected."
fi

# Check if the script is run from the right directory
if [ ! -f "home-manager/home.nix" ]; then
    log "ERROR" "home-manager/home.nix not found"
    log "ERROR" "Please run this script from the root of your dotfiles repository"
    exit 1
fi

print_section "Nix Installation"
if command -v nix >/dev/null; then
    # Check Nix version (assuming we want 2.18.0 or higher)
    nix_version=$(nix --version | cut -d' ' -f3)
    if [[ $(echo -e "2.18.0\n$nix_version" | sort -V | head -n1) == "2.18.0" ]]; then
        log "INFO" "Nix version $nix_version is already installed and up to date"
    else
        log "WARN" "Nix version $nix_version is installed but may be outdated"
        log "INFO" "Current version: $nix_version, Recommended: ≥2.18.0"
    fi
else
    log "INFO" "Installing Nix..."
    sh <(curl -L https://nixos.org/nix/install) --daemon || handle_error ${LINENO} nix_install

    # Wait for the Nix daemon to start
    sleep 2
    sudo systemctl restart nix-daemon.service

    # Source Nix using the multi-user daemon path
    if [ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then
        . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
    else
        log "ERROR" "Nix installation completed but profile script not found"
        exit 1
    fi
fi

print_section "Flakes Setup"
log "INFO" "Enabling flakes..."
mkdir -p ~/.config/nix
if ! grep -q "experimental-features = nix-command flakes" ~/.config/nix/nix.conf 2>/dev/null; then
    echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
fi
export NIX_CONFIG="experimental-features = nix-command flakes"

print_section "Home Manager Configuration"
log "INFO" "Creating Home Manager state directory..."
mkdir -p ~/.local/state/home-manager

log "INFO" "Applying Home Manager configuration..."
if ! nix run home-manager -- switch --flake ./home-manager#jkf; then
    handle_error ${LINENO} apply
    log "INFO" "You can try running 'home-manager switch --show-trace' for more detailed error information"
    exit 1
fi

print_section "SSH Key Setup"
log "INFO" "Would you like to set up an SSH key for GitHub? (y/N)"
read -p "$(echo -e ${BOLD}"(y/N) "${NC})" -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]; then
    log "INFO" "Please enter your GitHub email address:"
    read -p "$(echo -e ${BOLD}"Email: "${NC})" github_email

    log "INFO" "Generating SSH key..."
    ssh-keygen -t ed25519 -C "$github_email"

    log "INFO" "Starting ssh-agent..."
    eval "$(ssh-agent -s)"

    log "INFO" "Adding SSH key to agent..."
    ssh-add ~/.ssh/id_ed25519

    log "INFO" "Your public SSH key:"
    cat ~/.ssh/id_ed25519.pub

    log "INFO" "To complete setup:"
    log "INFO" "1. Copy the above public key"
    log "INFO" "2. Go to GitHub → Settings → SSH and GPG keys"
    log "INFO" "3. Click 'New SSH key'"
    log "INFO" "4. Paste your key and save"
fi

print_section "WSL Configuration"
log "INFO" "Would you like to create an optimized WSL configuration? (y/N)"
read -p "$(echo -e ${BOLD}"(y/N) "${NC})" -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]; then
    log "INFO" "Creating WSL configuration..."
    sudo tee /etc/wsl.conf > /dev/null << 'EOF'
# Windows drives mounting configuration
[automount]
# Automatically mount Windows drives
enabled = true
# Mount drives to /windir/ instead of /mnt/
root = /windir/
# Enable Linux file system metadata and set default file permissions
options = "metadata,uid=1000,gid=1000,umask=022,fmask=11"

# Enable systemd for modern Linux service management
[boot]
systemd = true

# Network configuration for WSL
[network]
# Auto-generate resolv.conf for DNS resolution
generateResolvConf = true
# Auto-generate hosts file
generateHosts = true

# Windows interoperability settings
[interop]
# Allow execution of Windows binaries
enabled = true
# Include Windows PATH in WSL environment
appendWindowsPath = true
EOF

    log "INFO" "WSL configuration created. Changes will take effect after WSL restart"
    log "INFO" "To apply changes, run 'wsl --shutdown' from PowerShell after installation"
fi

print_section "Installation Complete"
log "INFO" "Installation completed successfully! 🎉"
log "INFO" "Start a new shell session or run: source ~/.profile"
