# This file defines the "non-hardware dependent" part of opt-in persistence
# It imports impermanence, defines the basic persisted dirs, and ensures each
# users' home persist dir exists and has the right permissions
#
# It works even if / is tmpfs, btrfs snapshot, or even not ephemeral at all.
{
  inputs,
  ...
}:
{
  imports = [ inputs.impermanence.nixosModules.impermanence ];

  fileSystems."/persist".neededForBoot = true;

  environment.persistence = {
    "/persist" = {
      directories = [
        "/etc/NetworkManager/system-connections"
        "/var/lib/bluetooth"
        "/var/lib/systemd"
        "/var/lib/nixos"
        "/var/log"
        "/srv"
      ];
      # files = [
      #   "/etc/machine-id"
      #   "/etc/passwd"
      #   "/etc/shadow"
      # ];
    };
  };

  programs.fuse.userAllowOther = true;

  # system.activationScripts.persistent-dirs.text =
  #   let
  #     mkHomePersist = user:
  #       lib.optionalString user.createHome ''
  #         mkdir -p /persist/${user.home}
  #         chown ${user.name}:${user.group} /persist/${user.home}
  #         chmod ${user.homeMode} /persist/${user.home}
  #       '';
  #     users = lib.attrValues config.users.users;
  #   in
  #   lib.concatLines (map mkHomePersist users);
}
