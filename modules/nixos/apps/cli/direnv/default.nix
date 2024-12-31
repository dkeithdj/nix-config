{
  options,
  config,
  lib,
  configMk,
  ...
}:
let
  inherit (lib) mkIf types;
  inherit (configMk) mkBoolOpt;
  cfg = config.apps.cli.direnv;
in
{
  options.apps.cli.direnv = with types; {
    enable = mkBoolOpt false "Enable direnv";
  };

  config = mkIf cfg.enable {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true; # better than native direnv nix functionality - https://github.com/nix-community/nix-direnv
    };

    environment.sessionVariables.DIRENV_LOG_FORMAT = ""; # Blank so direnv will shut up
  };
}
