#!/bin/bash

# Exit on error
set -e

echo "Starting dotfiles installation..."

# Function to check if a binary is accessible in PATH
check_path() {
    if ! command -v "$1" >/dev/null 2>&1; then
        # Check if it exists in .local/bin but isn't in PATH
        if [ -f "$HOME/.local/bin/$1" ]; then
            echo "$1 found in ~/.local/bin but not in PATH"
            echo "Adding to PATH for current session..."
            export PATH="$HOME/.local/bin:$PATH"
        else
            return 1
        fi
    fi
    return 0
}

# Check for chezmoi and install if needed
if ! check_path chezmoi; then
    echo "Installing chezmoi..."
    sh -c "$(curl -fsLS get.chezmoi.io)" -- -b $HOME/.local/bin
    export PATH="$HOME/.local/bin:$PATH"
fi

# Verify chezmoi is now available
if ! command -v chezmoi >/dev/null 2>&1; then
    echo "Error: Failed to access chezmoi"
    echo "Please add ~/.local/bin to your PATH manually:"
    echo "export PATH=\$HOME/.local/bin:\$PATH"
    exit 1
fi

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Initialize chezmoi with the repository directory
echo "Initializing chezmoi..."
chezmoi init --apply "${SCRIPT_DIR}"

echo "Installation complete! Your dotfiles have been configured."
