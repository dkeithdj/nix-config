{pkgs, ...}: {
  fonts = {
    fontconfig.enable = true;
    packages = with pkgs; [
      (nerdfonts.override {fonts = ["FantasqueSansMono" "JetBrainsMono" "FiraMono"];})
    ];
  };
}
