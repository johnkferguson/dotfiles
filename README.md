# Dotfiles

A modern, declarative dotfiles setup for using [Nix][nixos.org] and [home-manager][home-manager manual] within a [WSL2][wsl docs] Linux envionment.

## Features

These dotfiles include a built in install script which does the following:

- Installs Nix as a multi-user daeomon
- Installs Nix packages
- Sets ups flakes
- Sets up home-manager and applies its configuration
- Offers the user the option to generate new SSH keys for the machine and describes how to add them to Github
- Offers the option to apply a default `/etc/wsl.conf` file for optimized WSL2 configuration

Some of the packages and home-manager configuration include:
- Git with WSL2-optimized settings.

## Quick Start

1. If you don't already have WSL2 setup in Windows, then install it via the command line or the through the Microsoft Store.

To install via the command line, open PowerShell (or Windows Command Prompt) and enter:

```powershell
wsl --install
```

To install via the Microsoft Store, search for "Ubuntu" in the Microsoft Store. The most recent LTS version as of this writing is [Ubuntu 24.04.1 LTS](https://www.microsoft.com/store/productId/9NZ3KLHXDJP5?ocid=pdpshare).

2. Next, clone the repository and run the install script:

```bash
git clone https://github.com/johnkferguson/dotfiles.git ~/.dotfiles && cd ~/.dotfiles && chmod +x bootstrap.sh && ./bootstrap.sh
```

3. Follow the prompts within the install script.

4. Enjoy your new working dev environment!

## Future Development

### Planned

- [ ] Fish configuration as default shell
- [ ] Bash configuration
- [ ] A way to easily copy outputs from the shell to the clipboard via `clip.exe`
- [ ] Customized and enhanced shell prompt

### Considering

- [ ] dir-env and environment variable handling
- [ ] A more elegant way to invoke `home-manager` without having to manually direct it to the right directory
- [ ] Semantic versioning for all changes to the dotfiles
   - [ ] Using [standard-version](https://github.com/conventional-changelog/standard-version) or [release-please
   ](https://github.com/googleapis/release-please)
- [ ] [Commitizen](https://commitizen-tools.github.io/commitizen/) for commit messages
- Pre-commit hooks for linting and formatting
- `wsl..conf` configurable and manageable within `home-manager`
- Docker and configuration to have it auto-start  on WSL2 boot
- [ ] Needed tools for js development environment, possibly including `pnpm` integrated well with Nix
- [ ] Needed tools for python development environment, possibly including `poetry` integrated well with Nix
- [ ] [Aider](https://mynixos.com/nixpkgs/package/aider-chat) for code review
- [ ] Some sort of AI CLI tool to help with git commit message generation
- [ ] Ability to easily set a different username to make it easier for others to use these dotfiles.
- [ ] Possible further VSCode integration (or is it possible to sync VSCode settings? separately from my local VSCode settings?)
- [ ] [lazygit](https://mynixos.com/nixpkgs/package/lazygit)
- [ ] Additional WSL2 optimizations (including [wslu](https://mynixos.com/nixpkgs/package/wslu)) and [gpu acceleration](https://learn.microsoft.com/en-us/windows/wsl/tutorials/gpu-compute)
- [ ] Environment state persistence to cover things Nix doesn't manage directly, like SSH keys or application data.

## Contributing

Suggestions and improvements welcome! Open an issue or PR to contribute.

[nixos.org]: https://nixos.org/
[home-manager manual]: https://nix-community.github.io/home-manager/
[wsl docs]: https://github.com/MicrosoftDocs/WSL
