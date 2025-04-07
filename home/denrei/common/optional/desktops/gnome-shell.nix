{ pkgs, ... }:
{
  programs.gnome-shell = {
    enable = true;
    extensions = [
      { package = pkgs.gnomeExtensions.clipboard-indicator; }
      { package = pkgs.gnomeExtensions.clipqr; }
      { package = pkgs.gnomeExtensions.smile-complementary-extension; }
    ];
  };
}
