#############################################################
#
#  Deneb - Macbook Pro 14 M4 Pro
#
###############################################################
{ lib, ... }:
{
  imports = lib.flatten [
    (map lib.custom.relativeToRoot [
      #################### Required Configs ####################
      "hosts/common/core"

      #################### Host-specific Optional Configs ####################
      # "hosts/common/optional/services/openssh.nix"
      # "hosts/common/optional/services/dropbox.nix" # dropbox
      # "hosts/common/optional/secure-boot"
      "hosts/common/optional/homebrew"

      # "hosts/common/optional/kanata/altair.nix" # keyboard colemak
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
  };

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-darwin";

  # Turn off NIX_PATH warnings now that we're using flakes
  system.checks.verifyNixPath = false;

  system.stateVersion = 5;
}
