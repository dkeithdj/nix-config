{ pkgs, ... }:
{
  fonts.fontconfig.enable = true;
  home.packages =
    [
      pkgs.noto-fonts
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
