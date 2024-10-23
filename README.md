# Dotfiles

These are my dotfiles.

This is for a WSL2 environment that utilizes the following:

* Windows 11
* Ubuntu 22.04.3 LTS
   * [Nix][nixos.org]
   * [home-manager][home-manager manual].


## Initial Setup

### Clone Options

HTTPS (requires GitHub credentials):
```bash
git clone https://github.com/johnkferguson/.dotfiles.git ~/dotfiles
```

SSH (requires SSH key setup):
```bash
git clone git@github.com:johnkferguson/dotfiles.git ~/.dotfiles
```

### Installation

After cloning the repository:
```bash
# Change to dotfiles directory
cd ~/.dotfiles

# Make install script executable
chmod +x install.sh

# Run the install script
./install.sh
```

> Note: The `chmod +x` command makes the script executable. This is necessary because files created in Windows/VSCode environments may not have execute permissions by default.

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
cd ~/.dotfiles

# Make install script executable
chmod +x install.sh

# Run the install script
./install.sh
```

> Note: The `chmod +x` command makes the script executable. This is necessary because files created in Windows/VSCode environments may not have execute permissions by default.

### After Install Todo

#### WSL Specific

For wsl for linux, it's best to have `/etc/wsl.conf` with the following [configuration](https://learn.microsoft.com/en-us/windows/wsl/wsl-config):

```
[automount]
enabled = true
root = /windir/

[boot]
systemd=true
```

## Directory Structure

```
# Repository structure
dotfiles/
├── README.md
├── install.sh
```

[nixos.org]: https://nixos.org/
[home-manager manual]: https://nix-community.github.io/home-manager/
