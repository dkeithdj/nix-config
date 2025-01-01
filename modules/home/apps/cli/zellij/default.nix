{
  config,
  pkgs,
  configVars,
  lib,
  configMk,
  ...
}:
let
  inherit (lib) mkIf types;
  inherit (configMk) mkOpt mkBoolOpt;
  cfg = config.apps.cli.zellij;
in
{
  options.apps.cli.zellij = with types; {
    enable = mkBoolOpt false "Enable zellij";
  };
  config = mkIf cfg.enable {
    xdg.configFile."zellij/config.kdl".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Projects/nix-config/modules/home/apps/cli/zellij/config.kdl";
    programs.zellij = {
      enable = true;
      package = pkgs.zellij;
      # enableBashIntegration = true;
      # enableZshIntegration = true;
    };
    # home.file.".config/zellij/config.kdl".source = ./config.kdl;
  };
}
