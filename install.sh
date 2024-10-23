#!/bin/bash

# Exit on any error
set -e

# Error handling function
handle_error() {
    echo "Error on line $1"
    case "$2" in
        nix_install) echo "Failed to install Nix. Check https://nixos.org/download.html for requirements." ;;
        channel) echo "Failed to add/update Home Manager channel. Check your internet connection." ;;
        hm_install) echo "Failed to install Home Manager." ;;
        config_link) echo "Failed to link configuration file." ;;
        apply) echo "Failed to apply Home Manager configuration." ;;
        *) echo "An unknown error occurred." ;;
    esac
}

# Set up error trap
trap 'handle_error ${LINENO} ${FUNCNAME:-unknown}' ERR

echo "Starting installation..."

# Check if running in WSL
if ! grep -q microsoft /proc/version; then
    echo "Warning: This script is designed for WSL. Some features might not work as expected."
fi

# Check if the script is run from the right directory
if [ ! -f "home-manager/home.nix" ]; then
    echo "Error: home-manager/home.nix not found"
    echo "Please run this script from the root of your dotfiles repository"
    exit 1
fi

echo "Installing Nix..."
if ! command -v nix >/dev/null; then
    # Backup any existing profile
    if [ -f ~/.profile ]; then
        cp ~/.profile ~/.profile.backup-"$(date +%Y%m%d-%H%M%S)"
    fi

    sh <(curl -L https://nixos.org/nix/install) --daemon || handle_error ${LINENO} nix_install

    # Source Nix
    if [ -f ~/.nix-profile/etc/profile.d/nix.sh ]; then
        . ~/.nix-profile/etc/profile.d/nix.sh
    else
        echo "Error: Nix installation completed but profile script not found"
        exit 1
    fi
else
    echo "Nix is already installed"
fi

echo "Installing Home Manager..."
# Add Home Manager channel
nix-channel --add https://github.com/nix-community/home-manager/archive/release-23.11.tar.gz home-manager || handle_error ${LINENO} channel
nix-channel --update || handle_error ${LINENO} channel

# Install Home Manager
echo "Installing Home Manager..."
nix-shell '<home-manager>' -A install || handle_error ${LINENO} hm_install

echo "Setting up Home Manager configuration..."
# Create config directory if it doesn't exist
mkdir -p ~/.config/home-manager

# Backup existing configuration if it exists
if [ -f ~/.config/home-manager/home.nix ]; then
    echo "Backing up existing Home Manager configuration..."
    cp ~/.config/home-manager/home.nix ~/.config/home-manager/home.nix.backup-"$(date +%Y%m%d-%H%M%S)"
fi

# Symlink our configuration
echo "Linking configuration file..."
ln -sf "$(pwd)/home-manager/home.nix" ~/.config/home-manager/home.nix || handle_error ${LINENO} config_link

echo "Applying configuration..."
# Try to apply configuration
if ! home-manager switch; then
    handle_error ${LINENO} apply
    echo "You can try running 'home-manager switch --show-trace' for more detailed error information"
    exit 1
fi

echo "Installation completed successfully!"
echo
echo "Note: Start a new shell session or run: source ~/.profile"
