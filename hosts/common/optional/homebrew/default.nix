{ pkgs, ... }:
{
  homebrew = {
    # This is a module from nix-darwin
    # Homebrew is *installed* via the flake input nix-homebrew
    enable = true;
    casks = pkgs.callPackage ./casks.nix { };

    # These app IDs are from using the mas CLI app
    # mas = mac app store
    # https://github.com/mas-cli/mas
    #
    # $ nix shell nixpkgs#mas
    # $ mas search <app name>
    #
    # masApps = {
    #   "hidden-bar" = 1452453066;
    #   "wireguard" = 1451685025;
    # };
  };
}
