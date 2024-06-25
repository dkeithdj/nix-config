{ pkgs, ... }: {
  home.packages = with pkgs; [
    vesktop
    qbittorrent
    neovide

    vial

    onlyoffice-bin_latest

    evince
    gnome-solanum

    postman

    zoom-us
  ];
}
