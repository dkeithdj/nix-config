{
  pkgs,
  lib,
  config,
  configVars,
  configMk,
  ...
}:
let
  inherit (lib) mkIf mkForce types;
  inherit (configMk) mkOpt mkBoolOpt;
  cfg = config.apps.gui.zed;
in
{
  options.apps.gui.zed = with types; {
    enable = mkBoolOpt false "Enable zed";
  };
  # xdg.configFile."zed/settings.json".source = lib.mkForce (
  #   config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Projects/nix-config/home/${configVars.username}/common/core/zed/settings.json"
  # );
  config = mkIf cfg.enable {
    xdg.configFile = {
      "zed/settings.json".source = mkForce (
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Projects/nix-config/modules/home/apps/gui/zed/settings.json"
      );
      "zed/keymap.json".source = mkForce (
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Projects/nix-config/modules/home/apps/gui/zed/keymap.json"
      );
    };

    programs.zed-editor = {
      enable = true;
      extensions = [
        "nix"
        "tokyo-night"
        "docker-compose"
        "dockerfile"
      ];
    };

    home.packages = with pkgs; [
      nil
      nixd
    ];
  };
}
