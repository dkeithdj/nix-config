{
  pkgs,
  lib,
  config,
  configMk,
  ...
}:
let
  inherit (lib) mkIf types;
  inherit (configMk) mkOpt mkBoolOpt;
  cfg = config.apps.gui.misc;
in
# progams without configurations
{
  options.apps.gui.misc = with types; {
    enable = mkBoolOpt false "Enable miscellaneous GUI programs";
  };

  config = mkIf cfg.enable {

    home.packages = with pkgs; [
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

      filelight
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
  };
}
