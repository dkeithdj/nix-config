{pkgs, ...}: {
  home.packages = with pkgs; [
    (mpv.override {scripts = [mpvScripts.mpris];})
    stable.calibre
    spotify
    obs-studio
  ];
}
