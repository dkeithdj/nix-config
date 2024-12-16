{
  pkgs,
  lib,
  config,
  configVars,
  ...
}: {
  xdg.configFile."zed/settings.json".source = lib.mkForce (
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Projects/nix-config/home/${configVars.username}/common/core/zed/settings.json"
  );

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
}
