{ ... }:
{
  imports = [
    #################### Required Configs ####################
    common/core

    #################### Host-specific Optional Configs ####################
    common/optional/theme.nix
    common/optional/sops.nix
    common/optional/ags.nix
    common/optional/starship.nix
    common/optional/gdrive.nix
    # common/optional/solana.nix
    common/optional/helper-scripts

    common/optional/fuzzel
    common/optional/desktops
    common/optional/browsers
    common/optional/media

    #################### Development ####################
    common/optional/development
    common/optional/development/code
    common/optional/development/zed
    common/optional/development/ghostty
    #################### Productivity ####################
    common/optional/productivity
    #################### Communication ####################
    common/optional/comms

    # common/optional/hyprpanel
    common/optional/rofi
  ];

  monitors = [
    {
      name = "DP-2";
      width = 2560;
      height = 1440;
      refreshRate = 75;
      primary = true;
      #vrr = 1;
    }
  ];

}
