{
  lib,
  pkgs,
  config,
  configVars,
  ...
}:
{

  xdg.configFile = {
    "rofi/config.rasi".source = lib.mkForce (
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Projects/nix-config/home/${configVars.username}/common/optional/rofi/config.rasi"
    );
    "rofi/themes/spotlight.rasi".source = lib.mkForce (
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Projects/nix-config/home/${configVars.username}/common/optional/rofi/themes/spotlight.rasi"
    );
  };

  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    plugins = with pkgs; [
      rofi-emoji
      rofi-calc
    ];
    configPath = "";
  };
}
