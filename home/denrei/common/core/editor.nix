{
  pkgs,
  configVars,
  ...
}: {
  programs.vscode = {
    enable = true;
    package = pkgs.vscode.fhsWithPackages (
      ps:
        with ps; [
          rustup
          zlib
          openssl.dev
          pkg-config
        ]
    );
  };
  programs.zed-editor = {
    enable = true;
    extensions = [
      "tokyo-night"
      "nix"
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
        font_family = "FantasqueSansM Nerd Font";
        line_height = {
          custom = 1.1;
        };
      };
    };
  };
  home.packages = with pkgs; [
    nixpkgs-fmt
  ];
}
