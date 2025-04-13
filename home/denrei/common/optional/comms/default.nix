{ pkgs, ... }:
{

  home.packages = builtins.attrValues {
    inherit (pkgs)
      #telegram-desktop
      vesktop
      slack
      zoom-us
      ;
    inherit (pkgs.kdePackages) filelight;
  };
}
