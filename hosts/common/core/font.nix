{ pkgs, ... }:
{
  fonts = {
    fontconfig.enable = true;
    packages = with pkgs.nerd-fonts; [
      ubuntu
      ubuntu-mono
      fantasque-sans-mono
      jetbrains-mono
      fira-mono
    ];
  };
}
