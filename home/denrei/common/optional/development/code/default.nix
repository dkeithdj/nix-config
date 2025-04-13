{
  pkgs,
  lib,
  config,
  ...
}:
{

  xdg.configFile = {
    "Code/User/settings.json".source = lib.mkForce (
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Projects/nix-config/home/${config.hostSpec.username}/common/optional/development/code/settings.json"
    );
    "Code/User/keybindings.json".source = lib.mkForce (
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Projects/nix-config/home/${config.hostSpec.username}/common/optional/development/code/keybindings.json"
    );
  };
  programs.vscode = {
    enable = true;
    package = pkgs.vscode.fhsWithPackages (
      ps: with ps; [
        rustup
        zlib
        openssl.dev
        pkg-config
      ]
    );
  };
}
