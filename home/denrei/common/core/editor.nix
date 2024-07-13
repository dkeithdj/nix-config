{pkgs, ...}: {
  programs.vscode = {
    enable = true;
    package = pkgs.vscode.fhsWithPackages (ps: with ps; [rustup zlib openssl.dev pkg-config]);
  };
  home.packages = with pkgs; [
    zed-editor
    nixpkgs-fmt
    git
    gcc
    gnumake
    unzip
    wget
    curl
    tree-sitter
    ripgrep
    fd
    fzf
    go
    python3
    nodejs

    prettierd
    marksman
    nil
    lua-language-server
    luarocks
    lua
    stylua
    alejandra
    nodePackages.eslint
    eslint_d
    nodePackages.prettier
    ruff-lsp
    black
    pyright
  ];
}
