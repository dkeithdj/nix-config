#############################################################
#
#  Altair - Desktop PC
#  NixOS running on Ryzen 7 5600, Radeon RX 6600, 32GB RAM
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
    inputs.hardware.nixosModules.common-cpu-amd
    inputs.hardware.nixosModules.common-gpu-amd
    inputs.hardware.nixosModules.common-pc-ssd

    #################### Secure Boot ####################
    # inputs.lanzaboote.nixosModules.lanzaboote

    #################### Disk Layout ####################
    inputs.disko.nixosModules.disko
    (lib.custom.relativeToRoot "hosts/common/disks/altair.nix")

    (map lib.custom.relativeToRoot [
      #################### Required Configs ####################
      "hosts/common/core"

      #################### Host-specific Optional Configs ####################
      "hosts/common/optional/services/openssh.nix"
      "hosts/common/optional/services/dropbox.nix" # dropbox
      # "hosts/common/optional/secure-boot"

      # Desktop
      # "hosts/common/optional/services/greetd.nix" # display manager
      "hosts/common/optional/hyprland.nix" # window manager
      # "hosts/common/optional/cosmic.nix" # cosmic de

      "hosts/common/optional/pipewire.nix" # audio
      "hosts/common/optional/vlc.nix" # media player
      # "hosts/common/optional/kanata/altair.nix" # keyboard colemak
      "hosts/common/optional/vial.nix" # keyboard vial
      # "hosts/common/optional/mariadb.nix" # media player
      "hosts/common/optional/ollama.nix" # ollama
      "hosts/common/optional/tailscale.nix" # ollama

      "hosts/common/optional/nautilus.nix" # file manager

      #################### Users to Create ####################
      # "hosts/common/users/denrei"
    ])
    ./altair.nix

  ];

  # ========== Host Specification ==========
  hostSpec = {
    hostName = "altair";
    persistFolder = "/persist"; # added for "completion" because of the disko spec that was used even though impermanence isn't actually enabled here yet.
  };
  # set custom autologin options. see greetd.nix for details
  # TODO is there a better spot for this?
  # autoLogin.enable = true;
  # autoLogin.username = "denrei";

  programs.ssh.startAgent = true;
  # services.gnome.gnome-keyring.enable = true;
  # TODO enable and move to greetd area? may need authentication dir or something?
  # security.pam.services.greetd.enableGnomeKeyring = true;
  security.pam.services.gdm-password.enableGnomeKeyring = true;

  networking = {
    # hostName = "altair";
    networkmanager.enable = true;
    enableIPv6 = false;
  };

  # kde connect
  networking.firewall = rec {
    allowedTCPPortRanges = [
      {
        from = 1714;
        to = 1764;
      }
    ];
    allowedUDPPortRanges = allowedTCPPortRanges;
    allowedTCPPorts = [
      80
      443
    ];
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings.General.Experimental = true; # for gnome-bluetooth percentage
  };
  services.blueman.enable = true;

  # dconf
  programs.dconf.enable = true;

  programs.virt-manager.enable = true;
  virtualisation = {
    podman.enable = true;
    docker.enable = true;
    libvirtd.enable = true;
  };

  # logind
  services.logind.extraConfig = ''
    HandlePowerKey=ignore
    HandleLidSwitch=suspend
    HandleLidSwitchExternalPower=ignore
  '';

  boot.initrd = {
    systemd.enable = true;
  };

  boot = {
    loader = {
      systemd-boot = {
        enable = true;
      };
      efi.canTouchEfiVariables = true;
      timeout = 3;
    };
  };
  services.xserver.videoDrivers = [ "amdgpu" ];
  # This is a fix to enable VSCode to successfully remote SSH on a client to a NixOS host
  # https://nixos.wiki/wiki/Visual_Studio_Code # Remote_SSH
  programs.nix-ld.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.05";
}
