{pkgs, ...}: {
  programs.nix-ld.libraries = with pkgs; [
    nodejs
    stdenv.cc.cc
    zlib
    fuse3
    icu
    nss
    openssl
    curl
    expat
    xorg.libX11
    vulkan-headers
    vulkan-loader
    vulkan-tools
  ];
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "python" ''
      export LD_LIBRARY_PATH=$NIX_LD_LIBRARY_PATH
      exec ${pkgs.python3}/bin/python "$@"
    '')
  ];
}
