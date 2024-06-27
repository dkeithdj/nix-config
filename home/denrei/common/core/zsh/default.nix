{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf;
  packageNames = map (p: p.pname or p.name or null) config.home.packages;
  hasPackage = name: lib.any (x: x == name) packageNames;
  hasExa = hasPackage "eza";
  hasSpecialisationCli = hasPackage "specialisation";
  hasAwsCli = hasPackage "awscli2";
  hasLazygit = hasPackage "lazygit";
  hasNeovim = config.programs.neovim.enable;
  hasShellColor = config.programs.shellcolor.enable;
  hasKitty = config.programs.kitty.enable;
  shellcolor = "${pkgs.shellcolord}/bin/shellcolor";
in {
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    initExtra =
      /*
      bash
      */
      ''
        function yy() {
          local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
          yazi "$@" --cwd-file="$tmp"
          if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
            cd -- "$cwd"
          fi
          rm -f -- "$tmp"
        }
                bindkey -s '^f' '. ${pkgs.cdproject}\r'

                bindkey "^p" up-line-or-beginning-search # Up
                bindkey "^n" down-line-or-beginning-search # Down
                bindkey "^k" up-line-or-beginning-search # Up
                bindkey "^j" down-line-or-beginning-search # Down
                bindkey -r "^u"
                bindkey -r "^d"

      '';

    history = {
      ignoreDups = true;
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };

    shellAliases = {
      jqless = "jq -C | less -r";

      s = mkIf hasSpecialisationCli "specialisation";

      ls = mkIf hasExa "eza";
      exa = mkIf hasExa "eza";

      v = mkIf hasNeovim "nvim";
      g = mkIf hasLazygit "lazygit";

      ck = mkIf hasKitty "clone-in-kitty --type os-window";

      awssw = mkIf hasAwsCli "export AWS_PROFILE=(aws configure list-profiles | fzf)";
      # awssw = aws-switch;
      grep = "grep --color=auto";
      egrep = "egrep --color=auto";
      fgrep = "fgrep --color=auto";
      # confirm before overwriting something

      # git
      "gs" = "git status";
      "gb" = "git branch";
      "gch" = "git checkout";
      "gc" = "git commit";
      "ga" = "git add";
      "gr" = "git reset --soft HEAD~1";

      cp = "cp -iv";
      mv = "mv -iv";
      rm = "rm -vI";
      bc = "bc -ql";
      mkd = "mkdir -pv";
      cat = "bat";

      nc = "cd $FLAKE && v";
      nhh = "nh home switch";
      nho = "nh os switch";

      ve = ". ${pkgs.setenv}";
    };

    zplug = {
      enable = true;
      zplugHome = "${config.xdg.dataHome}/zsh/zplug";
      plugins = [
        {name = "zsh-users/zsh-autosuggestions";}
        {name = "hlissner/zsh-autopair";}
        {name = "jeffreytse/zsh-vi-mode";}
        # { name = "themes/robbyrussell"; tags = [ as:theme from:oh-my-zsh ]; }

        {name = "zap-zsh/fzf";}
        {name = "Aloxaf/fzf-tab";}
        {name = "zap-zsh/exa";}
        {name = "zsh-users/zsh-syntax-highlighting";}
        {name = "MichaelAquilina/zsh-you-should-use";}
        {name = "esc/conda-zsh-completion";}
      ];
    };
  };
}
