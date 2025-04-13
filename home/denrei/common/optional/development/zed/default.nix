{
  pkgs,
  lib,
  config,
  ...
}:
{
  # xdg.configFile."zed/settings.json".source = lib.mkForce (
  #   config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Projects/nix-config/home/${configVars.username}/common/optional/core/zed/settings.json"
  # );
  xdg.configFile = {
    "zed/settings.json".source = lib.mkForce (
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Projects/nix-config/home/${config.hostSpec.username}/common/optional/development/zed/settings.json"
    );
    "zed/keymap.json".source = lib.mkForce (
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Projects/nix-config/home/${config.hostSpec.username}/common/optional/development/zed/keymap.json"
    );
    "zed/tasks.json".source = lib.mkForce (
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Projects/nix-config/home/${config.hostSpec.username}/common/optional/development/zed/tasks.json"
    );
  };

  programs.zed-editor = {
    enable = true;
    package = pkgs.zed-editor;
    # package = inputs.zed-editor.packages.${pkgs.system}.default;
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
