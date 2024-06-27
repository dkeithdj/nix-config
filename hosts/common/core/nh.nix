{
  config,
  pkgs,
  ...
}: {
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-sence 4d --keep 3";
    # flake = "${config.home.homeDirectory}/Projects/nix-config";
  };
}
