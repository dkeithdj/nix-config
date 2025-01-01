# Add your reusable home-manager modules to this directory, on their own file (https://nixos.wiki/wiki/Module).
# These should be stuff you would like to share with others, not your personal configurations.
{
  # List your module files here
  fonts = import ./fonts.nix;
  git = import ./apps/cli/git;
  gh = import ./apps/cli/gh;
  bash = import ./apps/cli/bash;
  bat = import ./apps/cli/bat;
  cliphist = import ./apps/cli/cliphist;
  yazi = import ./apps/cli/yazi;
  zoxide = import ./apps/cli/zoxide;
  nvim = import ./apps/cli/nvim;
  zellij = import ./apps/cli/zellij;
  zsh = import ./apps/cli/zsh;

  # gui
  zed = import ./apps/gui/zed;
  # terminal
  kitty = import ./terminal/kitty;
  wezterm = import ./terminal/wezterm;

  # theme
  dconf = import ./theme/dconf;
  gtk = import ./theme/gtk;
}
