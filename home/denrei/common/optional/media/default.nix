{pkgs, ...}: {
  home.packages = with pkgs; [
    (mpv.override {scripts = [mpvScripts.mpris];})
    calibre
    spotify
    obs-studio
  ];
}
