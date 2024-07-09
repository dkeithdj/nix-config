{pkgs, ...}: {
  home.packages = with pkgs;
    [
      vesktop
      qbittorrent
      neovide
      obsidian

      vial

      onlyoffice-bin_latest

      evince
      gnome-solanum

      postman

      zoom-us

      filelight

      # {package = pkgs.gnomeExtensions.clipboard-indicator;}
      # {package = pkgs.gnomeExtensions.clipqr;}
      # {package = pkgs.gnomeExtensions.smile-complementary-extension;}
    ]
    ++ (with gnomeExtensions; [clipboardqindicator clipqr smile-complementary-extension]);
}
