{
  lib,
  pkgs,
  config,
  ...
}:
{
  imports = lib.flatten [
    (map lib.custom.relativeToRoot [
      "modules/common/host-spec.nix"
      "hosts/common/core/ssh.nix"
      "hosts/common/users/primary"
      "hosts/common/users/primary/nixos.nix"
      "hosts/common/optional/minimal-user.nix"
    ])
  ];
  hostSpec = {
    isMinimal = lib.mkForce true;
    hostName = "installer";
    username = "denrei";
  };

  fileSystems."/boot".options = [ "umask=0077" ]; # Removes permissions and security warnings.
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot = {
    enable = true;
    # we use Git for version control, so we don't need to keep too many generations.
    configurationLimit = lib.mkDefault 3;
    # pick the highest resolution for systemd-boot's console.
    consoleMode = lib.mkDefault "max";
  };
  boot.initrd.systemd.enable = true;

  networking = {
    # configures the network interface(include wireless) via `nmcli` & `nmtui`
    networkmanager.enable = true;
  };

  services = {
    qemuGuest.enable = true;
    openssh = {
      enable = true;
      ports = [ 22 ]; # FIXME: Make this use configVars.networking
      settings.PermitRootLogin = "yes";
    };
  };

  environment.systemPackages = builtins.attrValues {
    inherit (pkgs)
      wget
      curl
      rsync
      ;
  };

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    warn-dirty = false;
  };
  system.stateVersion = "24.05";
}
