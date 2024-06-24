{ configVars, ... }:
{
  imports = [
    #################### Required Configs ####################
    common/core # required

    #################### Host-specific Optional Configs ####################
    common/optional/theme.nix
    common/optional/sops.nix
    common/optional/ags.nix
    common/optinal/starship.nix
    common/optional/helper-scripts

    common/optional/desktops
    common/optional/browsers
    common/optional/media
  ];

  home = {
    username = configVars.username;
    homeDirectory = "/home/${configVars.username}";
  };
}
