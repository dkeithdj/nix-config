{ pkgs, ... }:
{

  home.packages = builtins.attrValues {
    inherit (pkgs)
      qbittorrent # dunno where to put this
      obsidian
      onlyoffice-bin_latest
      vial
      smile
      ;
    inherit (pkgs.kdePackages)
      filelight
      ;
  };
}
