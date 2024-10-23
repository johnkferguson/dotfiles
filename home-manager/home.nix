
{ lib, pkgs, ... }:
{
  home = {
    # Install packages from https://search.nixos.org/packages
    packages = with pkgs; [
      hello
      git
    ];

    username = builtins.getEnv "USER";
    homeDirectory = "/home/${builtins.getEnv "USER"}";

    # Don't ever change this after the first build.
    # It tells home-manager what the original state schema
    # was, so it knows how to go to the next state.  It
    # should NOT update when you update your system!
    stateVersion = "23.11";
  };

  # Enable home-manager to manage itself
  programs.home-manager.enable = true;
}
