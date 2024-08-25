{pkgs, ...}: {
  services.desktopManager.cosmic.enable = true;
  services.displayManager.cosmic-greeter.enable = true;
  # environment.systemPackages = with pkgs; [cosmic-icons];

  # environment.systemPackages = [pkgs.drm_info pkgs.cosmic-emoji-picker pkgs.cosmic-tasks];
}
