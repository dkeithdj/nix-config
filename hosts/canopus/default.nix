#############################################################
#
#  Canopus - HP Laptop
#  NixOS running on Bare Metal
#
###############################################################
{
  inputs,
  configLib,
  configMk,
  ...
}:
let
  inherit (configMk) enabled disabled;
in
{
  imports =
    [
      #################### Every Host Needs This ####################
      ./hardware-configuration.nix

      #################### Hardware Modules ####################
      # inputs.hardware.nixosModules.common-cpu-amd
      # inputs.hardware.nixosModules.common-gpu-amd
      # inputs.hardware.nixosModules.common-pc-ssd

      #################### Disk Layout ####################
      inputs.disko.nixosModules.disko
      (configLib.relativeToRoot "hosts/common/disks/laptop-disk-config.nix")
      {
        _module.args = {
          disk = [
            "/dev/nvme0n1"
            "/dev/sda"
          ];
          withSwap = true;
          swapSize = "8";
        };
      }
    ]
    ++ (map configLib.relativeToRoot [
      #################### Required Configs ####################
      "hosts/common/core"

      #################### Host-specific Optional Configs ####################
      "hosts/common/optional/services/openssh.nix"
      "hosts/common/optional/services/dropbox.nix" # dropbox
      # "hosts/common/optional/secure-boot"

      # Desktop
      # "hosts/common/optional/services/greetd.nix" # display manager
      "hosts/common/optional/hyprland.nix" # window manager

      "hosts/common/optional/pipewire.nix" # audio
      "hosts/common/optional/vlc.nix" # media player
      "hosts/common/optional/kanata/canopus.nix" # keyboard colemak
      "hosts/common/optional/vial.nix" # keyboard vial
      # "hosts/common/optional/mariadb.nix" # media player
      "hosts/common/optional/nautilus.nix" # file manager

      #################### Users to Create ####################
      "hosts/common/users/denrei"
    ]);
  # set custom autologin options. see greetd.nix for details
  # TODO is there a better spot for this?
  # autoLogin.enable = true;
  # autoLogin.username = "denrei";

  system = {
    fonts = enabled;
  };

  apps = {
    cli = {
      nh.enable = true;
      direnv = enabled;
    };
  };

  programs.ssh.startAgent = true;
  # TODO enable and move to greetd area? may need authentication dir or something?
  security.pam.services.greetd.enableGnomeKeyring = true;

  networking = {
    hostName = "canopus";
    networkmanager.enable = true;
    # enableIPv6 = false;
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
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
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
