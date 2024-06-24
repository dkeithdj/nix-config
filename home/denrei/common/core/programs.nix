{ pkgs, ... }: {
  home.packages = with pkgs; [
    vesktop
    qbittorrent
    neovide
  ];
}
