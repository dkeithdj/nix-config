{
  pkgs,
  config,
  configVars,
  inputs,
  ...
}:
{
  # xdg.configFile."wezterm/wezterm.lua".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Projects/nix-config/home/${configVars.username}/common/core/wezterm/wezterm.lua";
  # # home.packages = with pkgs; [wezterm];
  # programs.wezterm = {
  #   package = inputs.wezterm.packages.${pkgs.system}.default;
  #   enable = true;
  #   enableZshIntegration = true;
  #   enableBashIntegration = true;
  # extraConfig = builtins.readFile ./wezterm.lua;
  # };
}
