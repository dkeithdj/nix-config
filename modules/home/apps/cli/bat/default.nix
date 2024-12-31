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
  cfg = config.apps.cli.bat;
in
{
  options = {
    apps.cli.bat = with types; {
      enable = mkBoolOpt false "Enable bat configuration";
    };
  };
  config = mkIf cfg.enable {
    programs.bat = {
      enable = true;
      config = {
        # Show line numbers, Git modifications and file header (but no grid)
        style = "numbers,changes,header";
      };
      extraPackages = builtins.attrValues {
        inherit (pkgs.bat-extras)
          batgrep # search through and highlight files using ripgrep
          batdiff # Diff a file against the current git index, or display the diff between to files
          batman
          ; # read manpages using bat as the formatter
      };
    };
  };
}
