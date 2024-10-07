{
  pkgs,
  config,
  configVars,
  ...
}: {
  # xdg.configFile.wezterm.source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Projects/nix-config/home/${configVars.username}/common/core/wezterm";
  programs.wezterm = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    extraConfig = builtins.readFile ./wezterm.lua;
  };
}
