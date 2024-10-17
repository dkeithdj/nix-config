# You can build these directly using 'nix build .#example'
{pkgs ? (import <nixpkgs> {}), ...}: rec {
  #################### Packages with external source ####################
  solana-cli = pkgs.callPackage ./solana-cli {};
}
