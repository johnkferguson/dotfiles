#!/bin/bash

# Exit on error
set -e

# Parse command line options
VERBOSE=false
DRY_RUN=""
while getopts "vn" opt; do
    case $opt in
        v) VERBOSE=true ;;
        n) DRY_RUN="--dry-run" ;;
        *) echo "Usage: $0 [-v] [-n]" >&2
           echo "  -v  Verbose output" >&2
           echo "  -n  Dry run (no changes)" >&2
           exit 1 ;;
    esac
done

# Set up chezmoi flags based on verbosity
CHEZMOI_VERBOSE=""
if [ "$VERBOSE" = true ]; then
    CHEZMOI_VERBOSE="--verbose"
fi

# Function to log verbose messages
log() {
    if [ "$VERBOSE" = true ]; then
        echo "$1"
    fi
}

echo "Starting dotfiles installation..."

# Check for required commands
if ! command -v git >/dev/null 2>&1; then
    echo "Error: git is required but not installed"
    exit 1
fi

CHEZMOI_BIN="$HOME/.local/bin/chezmoi"

# Install chezmoi if not already installed
if [ ! -f "$CHEZMOI_BIN" ]; then
    echo "Installing chezmoi..."
    if [ -n "$DRY_RUN" ]; then
        echo "[DRY RUN] Would install chezmoi to $CHEZMOI_BIN"
    else
        sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin"
    fi
fi

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
log "Using dotfiles from: $SCRIPT_DIR"

if [ -n "$DRY_RUN" ]; then
    echo "Showing changes that would be made:"
    echo "==================================="
    # Initialize chezmoi (quietly)
    "$CHEZMOI_BIN" init --source="$SCRIPT_DIR" >/dev/null 2>&1

    # Show only managed file changes
    echo "Changes to dotfiles:"
    "$CHEZMOI_BIN" managed | while read -r file; do
        if "$CHEZMOI_BIN" diff "$file" >/dev/null 2>&1; then
            echo "Changes in $file:"
            "$CHEZMOI_BIN" diff "$file"
            echo
        fi
    done
    echo "==================================="
    echo "Dry run completed. No changes were made."
else
    echo "Initializing chezmoi..."
    "$CHEZMOI_BIN" init --source="$SCRIPT_DIR" --force --apply $CHEZMOI_VERBOSE
    echo "Installation complete! Your dotfiles have been configured."
fi

echo
echo "NOTE: To use chezmoi in your current terminal session, either:"
echo "1. Start a new terminal session, or"
echo "2. Run: source ~/.bashrc, or"
echo "3. Run: export PATH=\$HOME/.local/bin:\$PATH"
