{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.apps.cli.git;
in
{
  options = {
    apps.cli.git = with types; {
      enable = mkEnableOption "Git";
      userName = mkOption {
        type = types.str;
        default = "Denrei Keith";
        description = ''
          The name to use for git commits.
        '';
      };
      userEmail = mkOption {
        type = types.str;
        default = "42316655+dkeithdj@users.noreply.github.com";
        description = ''
          The email to use for git commits.
        '';
      };
    };
  };

  config = mkIf cfg.enable {

    home.packages = with pkgs; [
      lazygit
    ];

    home.shellAliases = {
      # Git aliases
      gp = "git push -u origin";
      gs = "git status";
      gb = "git branch";
      gch = "git checkout";
      gc = "git commit";
      ga = "git add";
      gr = "git reset --soft HEAD~1";

      g = "lazygit";
    };
    programs.git = {
      enable = true;
      package = pkgs.gitAndTools.gitFull;
      userName = cfg.userName;
      userEmail = cfg.userEmail;
      extraConfig = {
        init.defaultBranch = "main";
        pull.rebase = "true";
        color.ui = true;
        core.editor = "nvim";
        credential.helper = "store";
        github.user = cfg.userName;
        push.autoSetupRemote = true;
      };
      # enable git Large File Storage: https://git-lfs.com/
      lfs.enable = true;
      ignores = [
        ".direnv"
        "result"
      ];
    };

    programs.ssh = {
      enable = true;

      addKeysToAgent = "yes";
      matchBlocks = {
        "git" = {
          host = "github.com";
          user = "git";
          forwardAgent = true;
          identitiesOnly = true;
          identityFile = [
            "~/.ssh/id_ed25519_github"
          ];
        };
      };
      # FIXME: This should probably be for git systems only?
      #controlMaster = "auto";
      #controlPath = "~/.ssh/sockets/S.%r@%h:%p";
      #controlPersist = "60m";
      #extraConfig = ''
      #Include config.d/*
      #'';
    };
  };
}
