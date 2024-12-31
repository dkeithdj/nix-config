{
  pkgs,
  lib,
  configMk,
  config,
  ...
}:
let
  inherit (lib) mkIf types;
  inherit (configMk) mkOpt mkBoolOpt;
  cfg = config.apps.cli.cliphist;
in
{
  options = {
    apps.cli.cliphist = with types; {
      enable = mkBoolOpt false "Enable cliphist configuration";
    };
  };
  config = mkIf cfg.enable {
    services.cliphist = {
      enable = true;
      allowImages = true;
    };
  };
}
