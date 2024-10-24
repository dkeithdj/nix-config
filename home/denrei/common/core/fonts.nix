{pkgs, ...}: {
  fonts.fontconfig.enable = true;
  home.packages = [
    pkgs.noto-fonts
    pkgs.nerdfonts.override
    {fonts = ["FantasqueSansMono"];}
    # pkgs.nerdfonts # loads the complete collection. look into overide for FiraMono or potentially mononoki
    # pkgs.nerdfonts.override
    # { fonts = [ "FantasqueSansMono" ]; }
    pkgs.meslo-lgs-nf
  ];
}
