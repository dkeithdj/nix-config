# Core home functionality that will only work on Linux
{
  lib,
  pkgs,
  ...
}:
{
  imports = lib.flatten [
    ./cliphist.nix
  ];

  services = {
    kdeconnect = {
      enable = true;
      indicator = true;
    };
  };
  home.packages = with pkgs; [
    wf-recorder
    wl-clipboard
  ];
}
