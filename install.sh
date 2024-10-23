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
if ! command -v nix >/dev/null; then
    # Backup any existing profile
    if [ -f ~/.profile ]; then
        log "INFO" "Backing up existing profile..."
        cp ~/.profile ~/.profile.backup-"$(date +%Y%m%d-%H%M%S)"
    fi

    log "INFO" "Installing Nix..."
    sh <(curl -L https://nixos.org/nix/install) --daemon || handle_error ${LINENO} nix_install

    # Source Nix
    if [ -f ~/.nix-profile/etc/profile.d/nix.sh ]; then
        . ~/.nix-profile/etc/profile.d/nix.sh
    else
        log "ERROR" "Nix installation completed but profile script not found"
        exit 1
    fi
else
    log "INFO" "Nix is already installed"
fi

print_section "Flakes Setup"
log "INFO" "Enabling flakes..."
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf

print_section "Home Manager Installation"
log "INFO" "Adding required channels..."
nix-channel --add https://nixos.org/channels/nixpkgs-unstable nixpkgs || handle_error ${LINENO} channel
nix-channel --update || handle_error ${LINENO} channel

# Set NIX_PATH
export NIX_PATH=$NIX_PATH:$HOME/.nix-defexpr/channels

log "INFO" "Installing Home Manager..."
nix profile install home-manager || handle_error ${LINENO} hm_install

print_section "Configuration Application"
log "INFO" "Applying Home Manager configuration..."
if ! home-manager switch --flake .#$USER; then
    handle_error ${LINENO} apply
    log "INFO" "You can try running 'home-manager switch --show-trace' for more detailed error information"
    exit 1
fi

print_section "Installation Complete"
log "INFO" "Installation completed successfully! 🎉"
log "INFO" "Start a new shell session or run: source ~/.profile"
