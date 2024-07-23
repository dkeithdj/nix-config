{pkgs, ...}: {
  home.packages = with pkgs; [
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
    smile
  ];
}
