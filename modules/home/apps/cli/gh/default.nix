{
  lib,
  config,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.apps.cli.gh;
in
{
  options = {
    apps.cli.gh = with types; {
      enable = mkEnableOption "GitHub CLI";
    };
  };

  config = mkIf cfg.enable {
    programs.gh = {
      enable = true;
      extensions = with pkgs; [ gh-markdown-preview ];
      settings = {
        git_protocol = "http";
        prompt = "enabled";
      };
    };
    programs.gh-dash = {
      enable = true;
    };
  };
}
