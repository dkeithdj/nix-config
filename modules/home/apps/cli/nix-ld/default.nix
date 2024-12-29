{
  config,
  lib,
  pkgs,
  configMk,
  ...
}:
let
  inherit (lib) types mkIf;
  inherit (configMk) mkBoolOpt;
  cfg = config.apps.cli.nix-ld;
in
{

  options.apps.cli.nix-ld = with types; {
    enable = mkBoolOpt false "Enable nix-ld";
  };

  config = mkIf cfg.enable {

    programs.nix-ld = {
      enable = true;
      package = pkgs.nix-ld;

      libraries = with pkgs; [
        gcc
        icu
        libcxx
        stdenv.cc.cc.lib
        zlib
      ];
    };
  };
}
