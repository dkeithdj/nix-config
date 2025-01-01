{
  lib,
  config,
  pkgs,
  configMk,
  ...
}:

with lib;
let
  inherit (lib) mkIf types;
  inherit (configMk) mkOpt mkBoolOpt;
  cfg = config.apps.cli.misc;
in
{
  options.apps.cli.misc = with types; {
    enable = mkBoolOpt false "Enable misc cli tools";
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      # Packages that don't have custom configs go here

      # TODO: spaces before comment are removed by nixpkgs-fmt

      # See: https://github.com/nix-community/nixpkgs-fmt/issues/305

      borgbackup # backups
      btop # resource monitor
      coreutils # basic gnu utils
      curl
      eza # ls replacement
      fd # tree style ls

      devenv # devenv
      findutils # find
      fzf # fuzzy search
      # gh # github cli
      jq # JSON pretty printer and manipulator
      # lazygit # git TUI
      lazydocker # docker TUI
      docker-compose
      nix-tree # nix package tree viewer
      ncdu # TUI disk usage
      pciutils
      pfetch # system info
      pre-commit # git hooks
      p7zip # compression & encryption
      ripgrep # better grep
      usbutils
      tree # cli dir tree viewer
      unzip # zip extraction
      unrar # rar extraction
      wget # downloader
      killall
      nixd # Nix LSP)
      alejandra # Nix formatter
      nixfmt-rfc-style
      nvd # Differ
      nix-diff # Differ, more detailed
      nix-output-monitor
      nh # Nice wrapper for NixOS and HM
      neofetch # system info
      fastfetch # system info
      awscli2
      wf-recorder
      wl-clipboard
      zip
      # transmission_4-gtk
      cliphist

      # dev stuff

      poetry
      uv
      # cargo

      # rustc

      rustup
      terraform
      go
      gopls
      python3
      nodejs
      deno
      yarn
      elixir
      gcc
      gnumake
      solc
      black
      marksman
      pnpm
      minikube
      kubectl

      nodePackages.aws-cdk
      nodePackages.eslint

      act
      qmk
      qmk_hid

      viu
      chafa
      ueberzugpp
      aws-sam-cli
    ];
  };
}
