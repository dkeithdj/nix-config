{ pkgs, ... }:
{
  # TODO add ttf-font-awesome or font-awesome for waybar
  fontProfiles = {
    enable = true;
    monospace = {
      family = "FantasqueSansM Nerd Font";
      package = pkgs.nerd-fonts.fantasque-sans-mono;
    };
    regular = {
      family = "Fira Sans";
      package = pkgs.fira;
    };
  };
}
