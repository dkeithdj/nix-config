{pkgs, ...}: {
  home.packages = builtins.attrValues {
    inherit
      (pkgs)
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
    package = pkgs.yazi.packages.${pkgs.system}.default; # if you use overlays, you can omit this
  };
}
