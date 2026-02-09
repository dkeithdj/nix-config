{
  pkgs,
  config,
  inputs,
  hostSpec,
  ...
}:
{
  xdg.configFile."wezterm/wezterm.lua".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Projects/nix-config/home/${config.hostSpec.username}/common/core/wezterm/wezterm.lua";
  # home.packages = with pkgs; [wezterm];
  programs.wezterm = {
    package = inputs.wezterm.packages.${pkgs.system}.default;
    enable = if hostSpec.isDarwin then false else true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    # extraConfig = builtins.readFile ./wezterm.lua;
  };
}
