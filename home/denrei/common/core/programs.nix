{
  pkgs,
  inputs,
  ...
}: {
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

    # drm_info
    # cosmic-tasks

    # appflowy
    # microsoft-edge-dev
    inputs.zen-browser.packages.x86_64-linux.default

    kdenlive
  ];
}
