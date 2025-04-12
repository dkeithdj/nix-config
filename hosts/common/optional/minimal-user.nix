{ config, ... }:
{

  # Set a temp password for use by minimal builds like installer and iso
  users.users.${config.hostSpec.username} = {
    isNormalUser = true;
    hashedPassword = "$6$dpK/TArdRNPcd9wF$EY0lO8sM/PTR0OamepacEvAaFXsbFKmByWxUSbyAlrFbBn/0xFpyRp7HsA8s2dahTR/HVPCzC4E1lwmClLj6D/";
    extraGroups = [ "wheel" ];
  };
}
