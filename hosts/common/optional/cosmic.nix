{pkgs, ...}: {
  services.desktopManager.cosmic.enable = false;
  services.displayManager.cosmic-greeter.enable = false;
  # environment.systemPackages = with pkgs; [cosmic-icons];

  # environment.systemPackages = [pkgs.drm_info pkgs.cosmic-emoji-picker pkgs.cosmic-tasks];
}
