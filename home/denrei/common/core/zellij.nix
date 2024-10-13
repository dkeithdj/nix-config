{pkgs, ...}: {
  programs.zellij = {
    enable = true;
    package = pkgs.zellij;
    enableBashIntegration = true;
    enableZshIntegration = true;
    settings = {
      theme = "Tokyo Night Storm";
      default_shell = "zsh";
    };
  };
}
