{ pkgs, ... }:
{

  home.packages = builtins.attrValues {
    inherit (pkgs)
      qbittorrent # dunno where to put this
      obsidian
      onlyoffice-desktopeditors
      vial
      smile
      anydesk
      ;
    inherit (pkgs.kdePackages)
      filelight
      ;
  };
}
