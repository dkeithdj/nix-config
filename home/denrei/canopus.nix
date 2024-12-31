{ configVars, configMk, ... }:
let
  inherit (configMk) enabled disabled;
in
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
  ];

  apps.cli = {
    git.enable = true;
    gh.enable = true;
    bash = enabled;
    bat = enabled;
    cliphist = enabled;
    yazi = enabled;
    zoxide = enabled;
  };

  terminal = {
    wezterm = enabled;
    kitty = enabled;
  };

  home = {
    username = configVars.username;
    homeDirectory = "/home/${configVars.username}";
  };
}
