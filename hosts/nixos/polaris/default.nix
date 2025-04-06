#############################################################
#
#  Polaris - QEMU VM
#  NixOS running on VM
#
###############################################################
{
  inputs,
  lib,
  ...
}:
{
  imports = lib.flatten [
    #################### Every Host Needs This ####################
    ./hardware-configuration.nix

    #################### Hardware Modules ####################
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-gpu-amd
    # inputs.hardware.nixosModules.common-pc-ssd

    #################### Disk Layout ####################
    inputs.disko.nixosModules.disko
    (lib.custom.relativeToRoot "hosts/common/disks/standard-disk-config.nix")
    {
      _module.args = {
        disk = "/dev/vda";
        withSwap = false;
      };
    }
    (map lib.custom.relativeToRoot [
      #################### Required Configs ####################
      "hosts/common/core"

      #################### Host-specific Optional Configs ####################
      "hosts/common/optional/services/openssh.nix"

      # Desktop
      # "hosts/common/optional/services/greetd.nix" # display manager
      "hosts/common/optional/hyprland.nix" # window manager
      # "hosts/common/optional/gnome.nix" # desktop environment
      "hosts/common/optional/pipewire.nix" # audio
      "hosts/common/optional/vlc.nix" # media player

      #################### Users to Create ####################
      # "hosts/common/users/denrei"
    ])
  ];
  # ========== Host Specification ==========
  hostSpec = {
    hostName = "polaris";
    persistFolder = "/persist"; # added for "completion" because of the disko spec that was used even though impermanence isn't actually enabled here yet.
  };
  # set custom autologin options. see greetd.nix for details
  # TODO is there a better spot for this?
  # autoLogin.enable = true;
  # autoLogin.username = "denrei";

  # services.gnome.gnome-keyring.enable = true;
  # TODO enable and move to greetd area? may need authentication dir or something?
  # services.pam.services.greetd.enableGnomeKeyring = true;

  networking = {
    networkmanager.enable = true;
    enableIPv6 = false;
  };

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      timeout = 3;
    };
  };

  # This is a fix to enable VSCode to successfully remote SSH on a client to a NixOS host
  # https://nixos.wiki/wiki/Visual_Studio_Code # Remote_SSH
  programs.nix-ld.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.05";
}
