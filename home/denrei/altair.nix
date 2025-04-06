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

    # common/optional/hyprpanel
    common/optional/rofi
  ];

  # home = {
  #   username = configVars.username;
  #   homeDirectory = "/home/${configVars.username}";
  # };

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
