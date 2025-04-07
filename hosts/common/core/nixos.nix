# Core functionality for every nixos host
{ lib, ... }:
{
  # Database for aiding terminal-based programs
  environment.enableAllTerminfo = true;
  # Enable firmware with a license allowing redistribution
  hardware.enableRedistributableFirmware = true;

  # This should be handled by config.security.pam.sshAgentAuth.enable
  security.sudo.extraConfig = ''
    Defaults lecture = never # rollback results in sudo lectures after each reboot, it's somewhat useless anyway
    Defaults pwfeedback # password input feedback - makes typed password visible as asterisks
    Defaults timestamp_timeout=120 # only ask for password every 2h
    # Keep SSH_AUTH_SOCK so that pam_ssh_agent_auth.so can do its magic.
    Defaults env_keep+=SSH_AUTH_SOCK
  '';

  #
  # ========== Nix Helper ==========
  #
  # Provide better build output and will also handle garbage collection in place of standard nix gc (garbace collection)
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 20d --keep 20";
  };

  #
  # ========== Localization ==========
  #
  i18n = {
    defaultLocale = lib.mkDefault "en_PH.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = lib.mkDefault "en_PH.UTF-8";
      LC_IDENTIFICATION = lib.mkDefault "en_PH.UTF-8";
      LC_MEASUREMENT = lib.mkDefault "en_PH.UTF-8";
      LC_MONETARY = lib.mkDefault "en_PH.UTF-8";
      LC_NAME = lib.mkDefault "en_PH.UTF-8";
      LC_NUMERIC = lib.mkDefault "en_PH.UTF-8";
      LC_PAPER = lib.mkDefault "en_PH.UTF-8";
      LC_TELEPHONE = lib.mkDefault "en_PH.UTF-8";
      LC_TIME = lib.mkDefault "en_PH.UTF-8";
    };
  };
  # location.provider = "geoclue2";
  time.timeZone = lib.mkDefault "Asia/Manila";
}
