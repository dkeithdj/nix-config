{
  config,
  lib,
  configMk,
  ...
}:
let
  inherit (lib) mkIf types;
  inherit (configMk) mkOpt mkBoolOpt;
  cfg = config.apps.cli.zoxide;
in
{
  options.apps.cli.zoxide = with types; {
    enable = mkBoolOpt false "Enable zoxide";
  };

  config = mkIf cfg.enable {

    programs.zoxide = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      options = [
        "--cmd cd" # replace cd with z and zi (via cdi)
      ];
    };
  };
}
