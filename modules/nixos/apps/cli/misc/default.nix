{
  options,
  config,
  pkgs,
  lib,
  ...
}:
with lib;
let
  cfg = config.apps.cli.misc;
in
{
  options.cli.apps.misc = with types; {
    enable = mkEnableOption "Enable misc apps";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      # Development
      git
      bat
      eza
      fzf
      viu
      chafa
      ueberzugpp
      fd
      pre-commit # git hooks
      ripgrep
      p7zip # compression & encryption
      devenv
      pre-commit
      jq # JSON pretty printer and manipulator

      # Util
      ncdu
      pciutils
      pfetch
      coreutils
      usbutils
      tree
      unzip
      unrar # rar extraction
      killall
      wget # downloader
      sshfs
      btop
      ffmpeg
      python3
      devenv # devenv
      findutils # find
      neofetch
      fastfetch
      zip
      cliphist
    ];
  };
}
