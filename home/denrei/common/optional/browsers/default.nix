#
#  TODO this is a placeholder list for now
#
{pkgs, ...}: {
  imports = [
    ./brave.nix
    ./firefox.nix
    ./zen.nix
  ];
}
