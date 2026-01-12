# Unified desktop switcher module
# Import this module once and set hostSpec.desktop to switch between desktops
{ lib, ... }:
{
  imports = [
    ../hyprland.nix
    ../cosmic.nix
    ../gnome.nix
  ];
}
