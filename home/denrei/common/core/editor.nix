{pkgs, ...}: {
  programs.vscode = {
    enable = true;
    package = pkgs.vscode.fhsWithPackages (ps: with ps; [rustup zlib openssl.dev pkg-config]);
  };
  home.packages = with pkgs; [
    zed-editor
    nixpkgs-fmt
  ];
}
