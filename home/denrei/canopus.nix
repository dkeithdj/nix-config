{ configVars, configMk, ... }:
let
  inherit (configMk) enabled disabled;
in
{
  imports = [
    #################### Required Configs ####################
    # common/core # required

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

  user = enabled;

  apps.cli = {
    git = enabled;
    gh = enabled;
    bash = enabled;
    bat = enabled;
    cliphist = enabled;
    misc = enabled;
    yazi = enabled;
    zoxide = enabled;
    nvim = enabled;
    zsh = enabled;
    zellij = enabled;
  };
  apps.gui = {
    zed = enabled;
    misc = enabled;
  };

  terminal = {
    wezterm = enabled;
    kitty = enabled;
  };

  theme = {
    dconf = enabled;
    gtk = enabled;
  };

  home = {
    username = configVars.username;
    homeDirectory = "/home/${configVars.username}";
  };
}
