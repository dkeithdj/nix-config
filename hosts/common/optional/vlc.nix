# VLC media player
{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.vlc
    pkgs.celluloid
  ];
}
