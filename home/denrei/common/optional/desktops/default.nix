{ lib, hostSpec, ... }:
{
  imports = lib.flatten [
    # Packages with custom configs go here

    (lib.optionals (hostSpec.desktop == "hyprland") [
      ./hyprland
      ../ags.nix
    ])

    ########## Utilities ##########
    #    ./services/dunst.nix # Notification daemon
    #    ./waybar.nix # infobar
    #./rofi-wayland.nix #app launcher
    #./swww.nix #wallpaper daemon

    # ./gtk.nix # mainly in gnome
    #    ./qt.nix # mainly in kde
    ./fonts.nix
  ];

}
