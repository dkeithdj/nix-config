# Add your reusable home-manager modules to this directory, on their own file (https://nixos.wiki/wiki/Module).
# These should be stuff you would like to share with others, not your personal configurations.
# { }:
# {
#   # List your module files here
#   fonts = import ./fonts.nix;
#   git = import ./apps/cli/git;
#   gh = import ./apps/cli/gh;
#   # my-module = import ./my-module.nix;
# }

# Add your reusable home-manager modules to this directory, on their own file (https://wiki.nixos.org/wiki/NixOS_modules).
# These are modules you would share with others, not your personal configurations.

{ lib, ... }:
{
  imports = lib.custom.scanPaths ./.;
}
