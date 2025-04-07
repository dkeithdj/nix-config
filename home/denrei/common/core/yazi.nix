{ pkgs, ... }:
{
  home.packages = builtins.attrValues {
    inherit (pkgs)
      yazi # file explorer
      file
      poppler
      unar
      ffmpegthumbnailer
      ;
  };
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
  };
}
