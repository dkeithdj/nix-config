{ pkgs, ... }:
{

  environment.systemPackages = with pkgs; [
    (mpv.override { scripts = [ mpvScripts.mpris ]; })
    calibre
    spotify
  ];
}
