{ pkgs, config, ... }:
{
  homebrew = {
    # This is a module from nix-darwin
    # Homebrew is *installed* via the flake input nix-homebrew
    enable = true;
    casks = pkgs.callPackage ./casks.nix { };
    brews = pkgs.callPackage ./brews.nix { };
    onActivation.cleanup = "uninstall";
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
    taps = builtins.attrNames config.nix-homebrew.taps;

    # These app IDs are from using the mas CLI app
    # mas = mac app store
    # https://github.com/mas-cli/mas
    #
    # $ nix shell nixpkgs#mas
    # $ mas search <app name>
    #
    masApps = {
      # Bitwarden = 1352778147;
      # "hidden-bar" = 1452453066;
      # "wireguard" = 1451685025;
    };
  };
}
