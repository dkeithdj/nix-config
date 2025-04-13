{ ... }:
{
  imports = [
    #################### Required Configs ####################
    common/core # required

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
    #################### Productivity ####################
    common/optional/productivity
    #################### Communication ####################
    common/optional/comms

    # common/optional/hyprpanel
    common/optional/rofi
  ];

  # home = {
  #   username = configVars.username;
  #   homeDirectory = "/home/${configVars.username}";
  # };
  monitors = [
    {
      name = "eDP-1";
      width = 1366;
      height = 768;
      refreshRate = 60;
      primary = true;
      #vrr = 1;
    }
  ];
}
