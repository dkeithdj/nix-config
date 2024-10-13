{pkgs, ...}: {
  programs.zellij = {
    enable = true;
    package = pkgs.zellij;
    settings = {
      theme = "Tokyo Night";
      default_shell = "zsh";
    };
  };
}
