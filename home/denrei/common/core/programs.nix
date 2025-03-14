{
  pkgs,
  inputs,
  ...
}:
{
  home.packages = with pkgs; [
    # (discord.override {
    #   withVencord = true;
    # })
    vesktop
    qbittorrent
    neovide
    obsidian

    vial

    onlyoffice-bin_latest

    evince
    gnome-solanum

    stable.postman

    stable.zoom-us

    kdePackages.filelight
    smile

    # drm_info
    # cosmic-tasks

    # appflowy
    # microsoft-edge-dev
    # inputs.zen-browser.packages.x86_64-linux.default

    qpaeq
    pulseaudio

    stable.kdenlive
    # slack
    zotero
  ];
}
