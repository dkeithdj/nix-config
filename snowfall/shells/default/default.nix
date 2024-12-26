{pkgs, ...}:
pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    treefmt

    alejandra
    python312Packages.mdformat
    shfmt

    libiconv
    nix
    home-manager
    git
    just
    pre-commit
    age
    ssh-to-age
    neovim
    gh
    sops
  ];
}
