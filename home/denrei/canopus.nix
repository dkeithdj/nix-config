{ configVars, ... }:
{
  imports = [
    #################### Required Configs ####################
    common/core #required

    #################### Host-specific Optional Configs ####################
    common/optional/sops.nix
    common/optional/ags.nix
    common/optional/helper-scripts

    common/optional/desktops
    common/optional/browsers
  ];

  home = {
    username = configVars.username;
    homeDirectory = "/home/${configVars.username}";
  };
}

