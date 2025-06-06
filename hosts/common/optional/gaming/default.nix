{ pkgs, ... }:
{

  programs.anime-game-launcher.enable = true; # Adds launcher and /etc/hosts rules
  programs.anime-games-launcher.enable = true;
  programs.honkers-railway-launcher.enable = true;
  programs.honkers-launcher.enable = true;
  programs.wavey-launcher.enable = true;
  programs.sleepy-launcher.enable = true;

  programs.steam = {
    protontricks = {
      enable = true;
      package = pkgs.protontricks;
    };
    package = pkgs.steam.override {
      extraPkgs =
        pkgs:
        (builtins.attrValues {
          inherit (pkgs.xorg)
            libXcursor
            libXi
            libXinerama
            libXScrnSaver
            ;

          inherit (pkgs.stdenv.cc.cc)
            lib
            ;

          inherit (pkgs)
            libpng
            libpulseaudio
            libvorbis
            libkrb5
            keyutils
            gperftools
            ;
        });
    };
    extraCompatPackages = [ pkgs.unstable.proton-ge-bin ];
  };

  #gamescope launch args set dynamically in home/<user>/common/optional/gaming
  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };
  # to run steam games in game mode, add the following to the game's properties from within steam
  # gamemoderun %command%
  programs.gamemode = {
    enable = true;
    settings = {
      #see gamemode man page for settings info
      general = {
        softrealtime = "on";
        inhibit_screensaver = 1;
      };
      gpu = {
        apply_gpu_optimisations = "accept-responsibility";
        gpu_device = 1; # The DRM device number on the system (usually 0), ie. the number in /sys/class/drm/card0/
        amd_performance_level = "high";
      };
      custom = {
        start = "${pkgs.libnotify}/bin/notify-send 'GameMode started'";
        end = "${pkgs.libnotify}/bin/notify-send 'GameMode ended'";
      };
    };
  };
  environment.systemPackages = with pkgs; [
    (lutris.override {
      extraLibraries = _pkgs: [
        libadwaita
      ];
    })
    mangohud
  ];
}
