{
  options,
  config,
  pkgs,
  lib,
  namespace,
  ...
}:
with lib;
with lib.${namespace}; let
  cfg = config.apps.tools.git;
  name = "Denrei Keith";
in {
  options.apps.tools.git = with types; {
    enable = mkBoolOpt false "Enable or disable git";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      git
      git-remote-gcrypt

      gh # GitHub cli

      lazygit
    ];
    cif.home.extraOptions = {
      programs.git = {
        enable = true;
        package = pkgs.gitAndTools.gitFull;
        userName = name;
        userEmail = "42316655+dkeithdj@users.noreply.github.com";
        aliases = {};
        extraConfig = {
          init.defaultBranch = "main";
          pull.rebase = "true";
          color.ui = true;
          core.editor = "nvim";
          credential.helper = "store";
          github.user = name;
          push.autoSetupRemote = true;
        };
        # enable git Large File Storage: https://git-lfs.com/
        lfs.enable = true;
        ignores = [".direnv" "result"];
      };
    };

    environment.shellAliases = {
      # Git aliases
      ga = "git add .";
      gc = "git commit -m ";
      gp = "git push -u origin";

      g = "lazygit";
    };

    home.configFile."lazygit/config.yml".source = ./lazygitConfig.yml;
  };
}
