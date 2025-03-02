{pkgs, ...}: {
  # fonts = {
  #   fontconfig.enable = true;
  #   packages = with pkgs; [
  #     (nerdfonts.override {fonts = ["FantasqueSansMono" "JetBrainsMono" "FiraMono"];})
  #   ];
  # };
  home.packages =
    [
      pkgs.noto-fonts

      # pkgs.nerdfonts # loads the complete collection. look into overide for FiraMono or potentially mononoki
      # pkgs.nerdfonts.override
      # { fonts = [ "FantasqueSansMono" ]; }
      pkgs.meslo-lgs-nf
    ]
    ++ (with pkgs.nerd-fonts; [
      ubuntu
      ubuntu-mono
      caskaydia-cove
      fantasque-sans-mono
      fira-code
      mononoki
    ]);
}
