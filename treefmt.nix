# treefmt.nix
{ pkgs, ... }:
{
  # Used to find the project root
  projectRootFile = "flake.lock";

  programs.yamlfmt.enable = true;

  programs.nixfmt.enable = pkgs.hostPlatform.system != "riscv64-linux";
  programs.deadnix.enable = true;

  # programs.shellcheck.enable = pkgs.hostPlatform.system != "riscv64-linux";
  programs.shfmt.enable = true;
  settings.formatter.shfmt.includes = [ "*.envrc" ];
}
