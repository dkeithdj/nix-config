{ pkgs, ... }: {
  home.packages = with pkgs; [
    vesktop
    qbittorrent
    neovide

    onlyoffice-bin_latest

    evince
    gnome-solanum

    postman

    zoom-us
  ];
}
