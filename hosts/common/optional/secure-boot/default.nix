{
  lib,
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    sbctl
  ];

  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };
  boot.loader.systemd-boot = {
    windows."Windows" = {
      title = "Windows 11";
      efiDeviceHandle = "HD0b";
    };
  };
}
