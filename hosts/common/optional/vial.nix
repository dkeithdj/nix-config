{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    gcc-arm-embedded
  ];
  services.udev.packages = with pkgs; [
    vial
    via
    qmk-udev-rules
  ];
}
