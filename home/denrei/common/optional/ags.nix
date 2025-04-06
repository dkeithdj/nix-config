{
  inputs,
  config,
  pkgs,
  ...
}:
{
  imports = [
    inputs.ags.homeManagerModules.default
  ];

  home.packages = with pkgs; [
    bun
    dart-sass
    fd
    brightnessctl
    swww
    inputs.matugen.packages.${system}.default
    slurp
    wf-recorder
    wl-clipboard
    wayshot
    swappy
    hyprpicker
    pavucontrol
    networkmanager
    gtk3
  ];

  xdg.configFile.ags.source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Projects/nix-config/home/${config.hostSpec.username}/common/optional/ags";

  programs.ags = {
    enable = true;
    configDir = null;
    extraPackages = with pkgs; [
      accountsservice
    ];
  };
}
