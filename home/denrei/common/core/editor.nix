{pkgs, ...}: {
  programs.vscode = {
    enable = true;
    package = pkgs.vscode.fhsWithPackages (ps: with ps; [rustup zlib openssl.dev pkg-config]);
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
      lsp = {
        enable = true;
        server = {
          enable = true;
          rust-analyzer = {
            enable = true;
            package = pkgs.rust-analyzer;
          };
        };
      };
      tab_size = 2;
      vim_mode = true;
      theme = "tokyo-night";
    };
  };
  home.packages = with pkgs; [
    nixpkgs-fmt
  ];
}
