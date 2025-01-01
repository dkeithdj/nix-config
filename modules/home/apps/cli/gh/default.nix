{
  lib,
  config,
  pkgs,
  configMk,
  ...
}:

with lib;
let
  inherit (lib) mkIf types;
  inherit (configMk) mkOpt mkBoolOpt;
  cfg = config.apps.cli.gh;
in
{
  options.apps.cli.gh = with types; {
    enable = mkBoolOpt false "Enable gh cli";
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
