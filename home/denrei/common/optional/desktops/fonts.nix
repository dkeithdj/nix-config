{pkgs, ...}: {
  # TODO add ttf-font-awesome or font-awesome for waybar
  fontProfiles = {
    enable = true;
    monospace = {
      family = "FantasqueSansM Nerd Font";
      package = pkgs.nerdfonts.override {fonts = ["FantasqueSansMono"];};
    };
    regular = {
      family = "Fira Sans";
      package = pkgs.fira;
    };
  };
}
