{
  pkgs,
  config,
  lib,
  configMk,
  ...
}:
let
  inherit (lib) mkIf types;
  inherit (configMk) mkOpt mkBoolOpt;
  cfg = config.apps.cli.yazi;
in
{
  options.apps.cli.yazi = with types; {
    enable = mkBoolOpt false "Enable yazi";
  };

  config = mkIf cfg.enable {
    home.packages = builtins.attrValues {
      inherit (pkgs)
        yazi # file explorer
        file
        poppler
        unar
        ffmpegthumbnailer
        ;
    };
    programs.yazi = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
    };
  };
}
