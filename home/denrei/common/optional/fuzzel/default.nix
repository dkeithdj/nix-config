{pkgs, ...}: {
  programs.fuzzel = {
    enable = true;
    package = pkgs.fuzzel;
    settings = {
      main = {
        terminal = "${pkgs.kitty}/bin/kitty";
        layer = "overlay";
        prompt = ">>  ";
        font = "FantasqueSansM Nerd Font";
      };

      colors = {
        background = "#171717";
        text = "#F7DCDE";
        selection = "#574144";
        selection-text = "#DEBFC2";
        border = "#574144";
        match = "#FFB2BC";
        selection-match = "#FFB2BC";
      };
      border = {
        radius = 17;
        width = 1;
      };
      dmenu = {
        exit-immediately-if-empty = "yes";
      };
    };
  };
}
