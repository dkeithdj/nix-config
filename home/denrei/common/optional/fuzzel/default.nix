{
  inputs,
  pkgs,
  ...
}:
{
  programs.fuzzel = {
    enable = false;
    package = pkgs.fuzzel;
    settings = {
      main = {
        terminal = "${inputs.wezterm.packages.${pkgs.system}.default}/bin/wezterm";
        layer = "overlay";
        prompt = ">>  ";
        font = "FantasqueSansM Nerd Font";
      };

      colors = {
        background = "171717ff";
        text = "F7DCDEff";
        selection = "574144ff";
        selection-text = "DEBFC2ff";
        border = "574144dd";
        match = "FFB2BCff";
        selection-match = "FFB2BCff";
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
