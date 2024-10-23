# Dotfiles

Personal dotfiles managed with chezmoi.

## Initial Setup

### Clone Options

HTTPS (requires GitHub credentials):
```bash
git clone https://github.com/johnkferguson/dotfiles.git ~/dotfiles
```

SSH (requires SSH key setup):
```bash
git clone git@github.com:johnkferguson/dotfiles.git ~/dotfiles
```

### SSH Key Setup
Required for pushing changes to GitHub. If you only need to pull/clone, you can skip this initially.

1. Generate a new SSH key:
   ```bash
   ssh-keygen -t ed25519 -C "witandcharm@gmail.com"
   ```
   - Press Enter to accept the default file location
   - Enter a secure passphrase when prompted

2. Start the ssh-agent:
   ```bash
   eval "$(ssh-agent -s)"
   ```

3. Add your SSH key to the ssh-agent:
   ```bash
   ssh-add ~/.ssh/id_ed25519
   ```

4. Copy your SSH public key:
   ```bash
   cat ~/.ssh/id_ed25519.pub
   ```

5. Add the key to your GitHub account:
   - Go to GitHub → Settings → SSH and GPG keys
   - Click "New SSH key"
   - Paste your key and save

## Installation

After cloning the repository:
```bash
# Change to dotfiles directory
cd ~/dotfiles

# Make install script executable
chmod +x install.sh

# Run the install script
./install.sh
```

> Note: The `chmod +x` command makes the script executable. This is necessary because files created in Windows/VSCode environments may not have execute permissions by default.

## What Gets Installed

The installation script will:
1. Install chezmoi if not already present
2. Initialize chezmoi with configurations from this repository
3. Apply the following configurations:
   - Git configuration (user name, email, default branch, etc.)
   - [Additional configurations to be listed as they're added]

## Directory Structure

```
# Repository structure (how files are stored in chezmoi)
dotfiles/
├── README.md
├── install.sh
└── dot_config/        # Will become ~/.config in your home directory
    └── git/
        └── config    # Will become ~/.config/git/config
```

## How Chezmoi Works

### File Organization
- Files in the repository are stored with special prefixes (like `dot_`)
- Chezmoi automatically transforms these when installing:
  - `dot_config/git/config` → `~/.config/git/config`
  - `dot_bashrc` → `~/.bashrc`

### Adding New Files
To add an existing config file to chezmoi's management:
```bash
# Example: Adding your bash configuration
chezmoi add ~/.bashrc
# This will copy ~/.bashrc to the chezmoi directory as dot_bashrc

# Example: Adding a config file
chezmoi add ~/.config/git/config
# This will copy the file to chezmoi's directory as dot_config/git/config
```

## Managing Your Dotfiles

### Updating Configurations
After making changes to your configurations:
```bash
chezmoi apply
```

### Checking Changes
To see what changes chezmoi would make:
```bash
chezmoi diff
```

### Edit Files
To edit a file managed by chezmoi:
```bash
chezmoi edit ~/.bashrc
```

### Adding New Files
To add a new file to be managed by chezmoi:
```bash
chezmoi add ~/.config/some-config-file
```

### Getting Updates
To pull the latest changes from your repository:
```bash
chezmoi update
```

## Troubleshooting

If you encounter any issues:
1. Check the status of chezmoi:
   ```bash
   chezmoi doctor
   ```
2. View what changes would be made:
   ```bash
   chezmoi diff
   ```
3. Reset changes if needed:
   ```bash
   chezmoi unmanage ~/.config/some-config-file
   ```
