{
  pkgs,
  config,
  lib,
  inputs,
  configMk,
  ...
}:
let
  inherit (lib) mkIf types;
  inherit (configMk) mkOpt mkBoolOpt;
  cfg = config.terminal.wezterm;
in
{
  options.terminal.wezterm = with types; {
    enable = mkBoolOpt false "Enable wezterm terminal emulator";
  };

  config = mkIf cfg.enable {
    xdg.configFile."wezterm/wezterm.lua".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Projects/nix-config/modules/home/terminal/wezterm/wezterm.lua";
    # home.packages = with pkgs; [wezterm];
    programs.wezterm = {
      package = inputs.wezterm.packages.${pkgs.system}.default;
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
      # extraConfig = builtins.readFile ./wezterm.lua;
    };
  };
}
