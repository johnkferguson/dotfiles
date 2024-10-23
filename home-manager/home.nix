{
  config,
  pkgs,
  ...
}: {
  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;

  # Basic information
  home = {
    username = "jkf";
    homeDirectory = "/home/jkf";
    stateVersion = "23.11"; # Please read the comment below
  };

  # Git configuration (from your current dot_config/git/config)
  programs.git = {
    enable = true;
    userName = "John K. Ferguson";
    userEmail = "witandcharm@gmail.com";

    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = false;
      core = {
        editor = "vim";
        autocrlf = "input";  # For WSL/Windows compatibility
      };
      color.ui = "auto";
      help.autocorrect = 1;
    };

    aliases = {
      st = "status";
      co = "checkout";
      br = "branch";
      ci = "commit";
      unstage = "reset HEAD --";
      last = "log -1 HEAD";
      lg = "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
    };
  };

  # Bash configuration (from your dot_bashrc)
  programs.bash = {
    enable = true;

    # Shell options
    historyControl = ["ignoreboth"];
    historySize = 1000;
    historyFileSize = 2000;

    # Your aliases
    aliases = {
      ll = "ls -alF";
      la = "ls -A";
      l = "ls -CF";
    };
  };

  # Initial set of packages
  home.packages = with pkgs; [
    git
    vim
    # Add more packages as needed
  ];
}
