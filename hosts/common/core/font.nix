{pkgs, ...}: {
  fonts = {
    fontconfig.enable = true;
    packages = with pkgs.nerd-fonts; [
      fantasque-sans-mono
      jetbrains-mono
      fira-mono
    ];
  };
}
