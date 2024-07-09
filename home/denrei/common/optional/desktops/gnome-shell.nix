{pkgs, ...}: {
  programs.gnome-shell = {
    enable = true;
    extensions = with pkgs.gnomeExtensions; [
      clipboard-indicator
      clipqr
      smile-complementary-extension
    ];
  };
}
