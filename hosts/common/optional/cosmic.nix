{
  config,
  lib,
  pkgs,
  ...
}:
{

  config = lib.mkIf (config.hostSpec.desktop == "cosmic") {
    services.desktopManager.cosmic.enable = true;
    services.displayManager.cosmic-greeter.enable = true;
    services.system76-scheduler.enable = true;
    # environment.systemPackages = with pkgs; [cosmic-icons];

    # environment.systemPackages = [pkgs.drm_info pkgs.cosmic-emoji-picker pkgs.cosmic-tasks];
    environment.cosmic.excludePackages = with pkgs; [
      cosmic-edit
    ];
  };
}
