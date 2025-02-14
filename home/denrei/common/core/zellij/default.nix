{
  config,
  pkgs,
  configVars,
  ...
}:
{
  xdg.configFile."zellij/config.kdl".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Projects/nix-config/home/${configVars.username}/common/core/zellij/config.kdl";
  programs.zellij = {
    enable = false;
    package = pkgs.zellij;
    # enableBashIntegration = true;
    # enableZshIntegration = true;
  };
  # home.file.".config/zellij/config.kdl".source = ./config.kdl;
}
