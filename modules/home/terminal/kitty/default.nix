{
  pkgs,
  config,
  lib,
  configMk,
  ...
}:
let
  inherit (lib) mkIf types;
  inherit (configMk) mkOpt mkBoolOpt;
  cfg = config.terminal.kitty;
in
{
  options.terminal.kitty = with types; {
    enable = mkBoolOpt false "Enable kitty terminal emulator";
  };

  config = mkIf cfg.enable {
    xdg.mimeApps = {
      associations.added = {
        "x-scheme-handler/terminal" = "kitty.desktop";
      };
      defaultApplications = {
        "x-scheme-handler/terminal" = "kitty.desktop";
      };
    };
    programs.kitty = {
      enable = true;
      font = {
        name = "FantasqueSansM Nerd Font";
        size = 12;
      };
      shellIntegration.enableBashIntegration = true;
      shellIntegration.enableZshIntegration = true;
      keybindings = {
        "f1" = "new_tab_with_cwd";
        "kitty_mod+enter" = "new_window_with_cwd";
        "kitty_mod+n" = "new_os_window_with_cwd";
        "kitty_mod+t" = "new_tab_with_cwd";
        "kitty_mod+h" = "kitty_scrollback_nvim";
        "kitty_mod+g" = "kitty_scrollback_nvim --config ksb_builtin_last_cmd_output";
      };
      themeFile = "tokyo_night_night";
      settings = {
        enable_audio_bell = false;
        allow_remote_control = "socket-only";
        listen_on = "unix:/tmp/kitty";
      };
      extraConfig = ''
        action_alias kitty_scrollback_nvim kitten $HOME/.local/share/nvim/lazy/kitty-scrollback.nvim/python/kitty_scrollback_nvim.py
        mouse_map ctrl+shift+right press ungrabbed combine : mouse_select_command_output : kitty_scrollback_nvim --config ksb_builtin_last_visited_cmd_output
      '';
    };
  };
}
