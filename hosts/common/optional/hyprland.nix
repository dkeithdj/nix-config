{
  pkgs,
  ...
}:
{
  programs.hyprland = {
    enable = true;
    # package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    xwayland.enable = true;
    # portalPackage =
    #   inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland; # default
  };

  xdg.portal = {
    enable = true;
    configPackages = [ pkgs.xdg-desktop-portal-hyprland ];
    extraPortals = [
      # pkgs.xdg-desktop-portal
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-hyprland
    ];
  };

  security = {
    polkit.enable = true;
    pam.services.ags = { };
  };

  environment.systemPackages = with pkgs; [
    morewaita-icon-theme
    adwaita-icon-theme
    qogir-icon-theme
    loupe
    nautilus
    baobab
    gnome-text-editor
    gnome-calendar
    gnome-system-monitor
    gnome-calculator
    wl-gammactl
    wl-clipboard
    wayshot
    pavucontrol
    brightnessctl
    swww
    gnome-boxes
    gnome-control-center
    gnome-weather
    gnome-clocks
    gnome-software # for flatpak
    gnome-bluetooth
  ];

  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };

  services = {
    xserver = {
      enable = true;
      displayManager = {
        gdm.enable = true;
      };
    };
    libinput = {
      mouse = {
        accelProfile = "flat";
        accelSpeed = "-0.5";
      };
    };
    gvfs.enable = true;
    devmon.enable = true;
    udisks2.enable = true;
    upower.enable = true;
    power-profiles-daemon.enable = true;
    accounts-daemon.enable = true;
    gnome = {
      evolution-data-server.enable = true;
      glib-networking.enable = true;
      gnome-keyring.enable = true;
      gnome-online-accounts.enable = true;
    };
  };

  # services.greetd = {
  #   enable = true;
  #   settings.default_session.command = pkgs.writeShellScript "greeter" ''
  #     export XKB_DEFAULT_LAYOUT=${config.services.xserver.xkb.layout}
  #     export XCURSOR_THEME=Qogir
  #     ${ags}/bin/greeter
  #   '';
  # };
  #
  # systemd.tmpfiles.rules = [
  #   "d '/var/cache/greeter' - greeter greeter - -"
  # ];
  #
  # system.activationScripts.wallpaper = let
  #   wp =
  #     pkgs.writeShellScript
  #     /*
  #     bash
  #     */
  #     "wp" ''
  #       CACHE="/var/cache/greeter"
  #       OPTS="$CACHE/options.json"
  #       HOME="/home/$(find /home -maxdepth 1 -printf '%f\n' | tail -n 1)"
  #
  #       mkdir -p "$CACHE"
  #       chown greeter:greeter $CACHE
  #
  #       if [[ -f "$HOME/.cache/ags/options.json" ]]; then
  #         cp $HOME/.cache/ags/options.json $OPTS
  #         chown greeter:greeter $OPTS
  #       fi
  #
  #       if [[ -f "$HOME/.config/background" ]]; then
  #         cp "$HOME/.config/background" $CACHE/background
  #         chown greeter:greeter "$CACHE/background"
  #       fi
  #     '';
  # in
  #   builtins.readFile wp;
}
