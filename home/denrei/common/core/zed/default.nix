{
  pkgs,
  configVars,
  ...
}: {
  programs.zed-editor = {
    enable = true;
    extensions = [
      "nix"
      "tokyo-night"
      "docker-compose"
      "dockerfile"
    ];
    userSettings = {
      buffer_font_family = "FantasqueSansM Nerd Font";
      buffer_font_fallbacks = ["Zed Plex Mono"];
      ui_font_family = "FantasqueSansM Nerd Font";
      assistant = {
        provider = "zed.dev";
      };
      lsp = {
        rust-analyzer = {
          binary = {
            path = "/home/${configVars.username}/.nix-profile/bin/rust-analyzer";
          };
        };
      };
      tab_size = 2;
      vim_mode = true;
      theme = "Tokyo Night";
      terminal = {
        alternate_scroll = "off";
        copy_on_select = false;
        dock = "bottom";
        env = {
          TERM = "wezterm";
        };
        font_family = "FantasqueSansM Nerd Font";
        line_height = {
          custom = 1.1;
        };
        option_as_meta = false;
        shell = "system";
        toolbar = {
          title = true;
        };
      };
      load_direnv = "shell_hook";
    };
  };
  home.packages = with pkgs; [
    nixpkgs-fmt
    nil
  ];
}
