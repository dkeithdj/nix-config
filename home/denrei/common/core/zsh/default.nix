{
  pkgs,
  lib,
  config,
  ...
}:
{
  # imports = [scripts = ./scripts.nix];
  home.file = {
    ".local/bin/cd-project".source = config.lib.file.mkOutOfStoreSymlink ./cd-project;
    ".local/bin/setenv".source = config.lib.file.mkOutOfStoreSymlink ./setenv;
  };
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;
    dotDir = ".config/zsh";

    zplug = {
      enable = false;
      zplugHome = "${config.xdg.dataHome}/zsh/zplug";
      plugins = [
        { name = "zsh-users/zsh-autosuggestions"; }
        {
          name = "ptavares/zsh-terraform";
        }
        { name = "hlissner/zsh-autopair"; }
        { name = "jeffreytse/zsh-vi-mode"; }
        # { name = "themes/robbyrussell"; tags = [ as:theme from:oh-my-zsh ]; }

        { name = "zap-zsh/fzf"; }
        { name = "Aloxaf/fzf-tab"; }
        { name = "zap-zsh/exa"; }
        { name = "zsh-users/zsh-syntax-highlighting"; }
        { name = "MichaelAquilina/zsh-you-should-use"; }
        # {name = "esc/conda-zsh-completion";}
      ];
    };

    antidote = {
      enable = true;
      plugins = [
        "zsh-users/zsh-autosuggestions"
        "hlissner/zsh-autopair"
        "jeffreytse/zsh-vi-mode"
        "Atlas34/fzf-plugin"
        "Aloxaf/fzf-tab"
        "zap-zsh/exa"
        "zdharma-continuum/fast-syntax-highlighting"
        "MichaelAquilina/zsh-you-should-use"
        "ptavares/zsh-terraform"
      ];
    };

    initExtra =
      # bash
      ''
        source ~/.nix-profile/bin/aws_zsh_completer.sh

        bindkey "''${key[Up]}" up-line-or-search

        function yy() {
          local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
          yazi "$@" --cwd-file="$tmp"
          if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
            cd -- "$cwd"
          fi
          rm -f -- "$tmp"
        }
        bindkey -s '^g' '. cd-project\r'

        bindkey "^p" up-line-or-beginning-search # Up
        bindkey "^n" down-line-or-beginning-search # Down
        bindkey "^k" up-line-or-beginning-search # Up
        bindkey "^j" down-line-or-beginning-search # Down
        bindkey -r "^u"
        bindkey -r "^d"
        eval "$(direnv hook zsh)"
      '';

    history = {
      ignoreDups = true;
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };

    shellAliases = {
      jqless = "jq -C | less -r";

      ls = "eza";
      exa = "eza";

      v = "nvim";
      g = "lazygit";
      z = "zellij";

      ck = "clone-in-kitty --type os-window";

      awssw = "export AWS_PROFILE=$(aws configure list-profiles | fzf)";
      # awssw = aws-switch;
      grep = "grep --color=auto";
      egrep = "egrep --color=auto";
      fgrep = "fgrep --color=auto";
      # confirm before overwriting something

      # git
      gs = "git status";
      gb = "git branch";
      gch = "git checkout";
      gc = "git commit";
      ga = "git add";
      gr = "git reset --soft HEAD~1";

      cp = "cp -iv";
      mv = "mv -iv";
      rm = "rm -vI";
      bc = "bc -ql";
      mkd = "mkdir -pv";

      #-------------Bat related------------
      cat = "bat --paging=never";
      diff = "batdiff";
      rg = "batgrep";
      man = "batman";

      #-----------Nix commands----------------
      ncv = "cd $FLAKE && v";
      nhh = "nh home switch";
      nho = "nh os switch";

      ve = ". setenv";
      #-------------SSH---------------
      ssh = "TERM=xterm ssh";
    };
  };
}
