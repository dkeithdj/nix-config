{ pkgs, ... }: {
  home.packages = with pkgs; [
    vesktop
    qbittorrent
    neovide

    dropbox
    dropbox-cli

    onlyoffice-bin_latest

    evince
    gnome-solanum
  ];
}
