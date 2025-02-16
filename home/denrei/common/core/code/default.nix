{
  pkgs,
  lib,
  config,
  configVars,
  ...
}:
{

  xdg.configFile = {
    "Code/User/settings.json".source = lib.mkForce (
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Projects/nix-config/home/${configVars.username}/common/core/code/settings.json"
    );
    "Code/User/keybindings.json".source = lib.mkForce (
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Projects/nix-config/home/${configVars.username}/common/core/code/keybindings.json"
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
