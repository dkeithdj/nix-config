{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
{
  # xdg.configFile."zed/settings.json".source = lib.mkForce (
  #   config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Projects/nix-config/home/${configVars.username}/common/core/zed/settings.json"
  # );
  xdg.configFile = {
    "zed/settings.json".source = lib.mkForce (
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Projects/nix-config/home/${config.hostSpec.username}/common/core/zed/settings.json"
    );
    "zed/keymap.json".source = lib.mkForce (
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Projects/nix-config/home/${config.hostSpec.username}/common/core/zed/keymap.json"
    );
    "zed/tasks.json".source = lib.mkForce (
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Projects/nix-config/home/${config.hostSpec.username}/common/core/zed/tasks.json"
    );
  };

  programs.zed-editor = {
    enable = true;
    package = inputs.zed-editor.packages.${pkgs.system}.default;
    extensions = [
      "nix"
      "lua"
      "ruff"
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
