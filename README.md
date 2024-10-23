# Dotfiles

These are my dotfiles.

This is for a [WSL2][wsl docs] environment that utilizes the following:

* Windows 11
* Ubuntu 22.04.3 LTS
   * [Nix][nixos.org]
   * [home-manager][home-manager manual].

## Initial Setup

### WSL Installation

1. Open PowerShell as Administrator and run:
```bash
wsl --install -d Ubuntu
```

2. Launch Ubuntu by running this command in PowerShell:

```bash
ubuntu
```

3. Create your username and password when prompted.

### Clone Options

HTTPS (requires GitHub credentials):
```bash
git clone https://github.com/johnkferguson/.dotfiles.git ~/dotfiles
```

SSH (requires SSH key setup):
```bash
git clone git@github.com:johnkferguson/dotfiles.git ~/.dotfiles
```

### Post-Installation

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

[nixos.org]: https://nixos.org/
[home-manager manual]: https://nix-community.github.io/home-manager/
[wsl docs]: https://github.com/MicrosoftDocs/WSL
