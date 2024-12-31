{
  lib,
  config,
  pkgs,
  ...

}:
with lib;
let
  cfg = config.apps.cli.nh;
in
{
  options = {
    apps.cli.nh = with pkgs; {
      enable = mkEnableOption "Enable NH";
    };
  };
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      nh
    ];
    programs.nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-sence 4d --keep 3";
    };
  };
}
