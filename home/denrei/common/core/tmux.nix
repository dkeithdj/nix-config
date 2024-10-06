{pkgs, ...}: {
  programs.tmux = {
    enable = true;
    clock24 = true;
    extraConfig = ''      # used for less common options, intelligently combines if defined in multiple places.
         ...
    '';
  };
}
