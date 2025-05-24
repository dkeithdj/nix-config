#############################################################
#
#  Deneb - Macbook Pro 14 M4 Pro
#
###############################################################
{
  lib,
  ...
}:
{
  imports = lib.flatten [

    (map lib.custom.relativeToRoot [
      #################### Required Configs ####################
      "hosts/common/core"

      #################### Host-specific Optional Configs ####################
      # "hosts/common/optional/services/openssh.nix"
      # "hosts/common/optional/services/dropbox.nix" # dropbox
      # "hosts/common/optional/secure-boot"

      "hosts/common/optional/kanata/deneb.nix" # keyboard graphite
      # "hosts/common/optional/vial.nix" # keyboard vial
      # "hosts/common/optional/ollama.nix" # ollama
      # "hosts/common/optional/tailscale.nix" # ollama

      #################### Users to Create ####################
      # "hosts/common/users/denrei"
    ])
  ];

  # ========== Host Specification ==========
  hostSpec = {
    hostName = "deneb";
    isDarwin = true;
  };

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-darwin";
  system.primaryUser = "denrei";

  # Turn off NIX_PATH warnings now that we're using flakes
  system.checks.verifyNixPath = false;

  system.defaults = {
    dock.autohide = true;
    dock.expose-group-apps = true;
    spaces.spans-displays = true;
    finder.FXPreferredViewStyle = "clmv";
    loginwindow.GuestEnabled = false;
    NSGlobalDomain = {
      AppleICUForce24HourTime = true;
      AppleInterfaceStyle = "Dark";
      AppleShowAllExtensions = true;
      ApplePressAndHoldEnabled = false;
      NSWindowShouldDragOnGesture = true;

      # 120, 90, 60, 30, 12, 6, 2
      KeyRepeat = 2;

      # 120, 94, 68, 35, 25, 15
      InitialKeyRepeat = 15;

      "com.apple.sound.beep.volume" = 0.0;
      "com.apple.sound.beep.feedback" = 0;
    };

  };
  security.pam.services.sudo_local.touchIdAuth = true;
  security.pam.services.sudo_local.reattach = true;

  system.stateVersion = 5;
}
