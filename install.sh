#!/bin/bash

# Exit on error
set -e

echo "Starting dotfiles installation..."

CHEZMOI_BIN="$HOME/.local/bin/chezmoi"

# Install chezmoi if not already installed
if [ ! -f "$CHEZMOI_BIN" ]; then
    echo "Installing chezmoi..."
    sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin"
fi

# Initialize chezmoi with the repository directory, using full path
echo "Initializing chezmoi..."
"$CHEZMOI_BIN" init --source="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)" --force --apply

echo "Installation complete! Your dotfiles have been configured."
echo
echo "NOTE: To use chezmoi in your current terminal session, either:"
echo "1. Start a new terminal session, or"
echo "2. Run: source ~/.bashrc, or"
echo "3. Run: export PATH=\$HOME/.local/bin:\$PATH"
