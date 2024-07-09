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
      gnome-extensions-cli
    ]
    ++ (with gnomeExtensions; [clipboard-indicator clipqr smile-complementary-extension]);
}
