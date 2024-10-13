{pkgs, ...}: {
  programs.zellij = {
    enable = true;
    package = pkgs.zellij;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };
  home.file.".config/zellij/config.kdl".source = ./config.kdl;
}
