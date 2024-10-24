{ lib, pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      hello
      git
    ];

    username = "jkf";
    homeDirectory = "/home/jkf";
    stateVersion = "23.11";
  };

  programs.git = {
    enable = true;
    userName = "John K. Ferguson";
    userEmail = "witandcharm@gmail.com";

    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = false;

      core = {
        # 'code --wait' sets VSCode as the git editor
        # The '--wait' flag is crucial - it makes the git command wait
        # until you close the file in VSCode. Without this:
        # - Git might continue before you finish editing
        # - Commit messages might be empty
        # - Interactive operations might fail
        editor = "code --wait";

        # autocrlf = input handles line ending conversions:
        # - When checking out code: No conversion
        # - When committing code: Converts CRLF (Windows) to LF (Unix)
        # This is important in WSL2 because Windows uses CRLF line endings
        # while Linux uses LF. Setting to 'input' prevents conflicts.
        autocrlf = "input";
      };

      color.ui = "auto";

      alias = {
        st = "status";
        co = "checkout";
        br = "branch";
        ci = "commit";

        # 'unstage' removes files from the staging area
        # equivalent to 'git reset HEAD <file>'
        unstage = "reset HEAD --";

        # 'last' shows the details of your most recent commit
        # equivalent to 'git log -1 HEAD'
        last = "log -1 HEAD";

        # 'lg' creates a prettier git log with a graph
        # - %h: abbreviated commit hash
        # - %d: ref names (branch, tags)
        # - %s: commit subject (message)
        # - %cr: committer date, relative
        # - %an: author name
        lg = "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
      };

      help = {
        # When you mistype a command, git will correct and execute it
        # Example: 'git stauts' will run 'git status'
        # The value 1 means it waits 0.1 seconds before running the corrected command
        # This gives you a chance to see what command is actually being run
        autocorrect = 1;
      };
    };
  };

  programs.home-manager.enable = true;
}
