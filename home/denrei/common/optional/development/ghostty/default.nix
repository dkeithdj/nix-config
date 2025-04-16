{ pkgs, inputs, ... }:
{

  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    installVimSyntax = true;
    package = inputs.ghostty.packages.${pkgs.system}.default;
    settings = {
      theme = "tokyonight_night";
      font-family = "FantasqueSansM Nerd Font Propo";
      font-feature = "feat";
      focus-follows-mouse = true;
      mouse-hide-while-typing = true;
      scrollback-limit = 1000000;
      window-save-state = "always";
      window-decoration = "server";
    };
  };
}
