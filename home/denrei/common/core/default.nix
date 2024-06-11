{ config
, lib
, pkgs
, outputs
, inputs
, configLib
, ...
}:
{
  imports =
    (configLib.scanPaths ./.)
    ++ (builtins.attrValues outputs.homeManagerModules);
  # ++ [ inputs.impermanence.nixosModules.home-manager.impermanence ];

  services.ssh-agent.enable = true;

  home = {
    username = lib.mkDefault "denrei";
    homeDirectory = lib.mkDefault "/home/${config.home.username}";
    stateVersion = lib.mkDefault "24.05";
    sessionPath = [
      "$HOME/.local/bin"
      "$HOME/scripts/talon_scripts"
    ];
    sessionVariables = {
      FLAKE = "$HOME/src/nix-config";
      SHELL = "zsh";
      TERM = "kitty";
      TERMINAL = "kitty";
      EDITOR = "nvim";
      # MANPAGER = "batman"; # see ./cli/bat.nix
      # BAT_THEME = "base16";
      # GOPATH = "${config.home.homeDirectory}/.local/share/go";
      # GOMODCACHE = "${config.home.homeDirectory}/.cache/go/pkg/mod";
    };


    # persistence = {
    #   "/persist/home/denrei" = {
    #     # defaultDirectoryMethod = "symlink";
    #     directories = [
    #       "Documents"
    #       "Downloads"
    #       "Pictures"
    #       "Videos"
    #       "Music"
    #       "VirtualBox VMs"
    #       ".gnupg"
    #       ".ssh"
    #       ".nixops"
    #       ".local/share/keyrings"
    #       ".local/share/direnv"
    #       ".local/bin"
    #       ".local/share/zsh/"
    #       ".local/share/nvim/"
    #       ".local/share/nix" # trusted settings and repl history
    #     ];
    #     allowOther = true;
    #   };
    # };
  };

  gtk.gtk3.bookmarks =
    let
      home = config.home.homeDirectory;
    in
    [
      "file://${home}/Documents"
      "file://${home}/Music"
      "file://${home}/Pictures"
      "file://${home}/Videos"
      "file://${home}/Downloads"
      "file://${home}/Desktop"
    ];
  services = {
    kdeconnect = {
      enable = true;
      indicator = true;
    };
  };
  # home.packages = let nerdfonts = pkgs.nerdfonts.override {
  #     fonts = [
  #     "Ubuntu" "UbuntuMono" "CascadiaCode" "FantasqueSansMono" "FiraCode"
  #     ];
  #   }; in [nerdfonts];

  home.packages =
    let nerdfonts = pkgs.nerdfonts.override {
      fonts = [
        "Ubuntu"
        "UbuntuMono"
        "CascadiaCode"
        "FantasqueSansMono"
        "FiraCode"
      ];
    }; in
    [ nerdfonts ] ++
    builtins.attrValues {
      inherit (pkgs)
        # Packages that don't have custom configs go here

        # TODO: spaces before comment are removed by nixpkgs-fmt

        # See: https://github.com/nix-community/nixpkgs-fmt/issues/305

        borgbackup# backups
        btop# resource monitor
        coreutils# basic gnu utils
        # curl

        eza# ls replacement
        fd# tree style ls
        findutils# find
        fzf# fuzzy search
        gh# github cli
        jq# JSON pretty printer and manipulator
        lazygit# git TUI
        lazydocker# docker TUI
        nix-tree# nix package tree viewer
        ncdu# TUI disk usage
        pciutils
        pfetch# system info
        pre-commit# git hooks
        p7zip# compression & encryption
        ripgrep# better grep
        usbutils
        tree# cli dir tree viewer
        unzip# zip extraction
        unrar# rar extraction
        wget# downloader

        nixd# Nix LSP
        alejandra# Nix formatter
        nixfmt-rfc-style
        nvd# Differ
        nix-diff# Differ, more detailed
        nix-output-monitor
        nh# Nice wrapper for NixOS and HM
        neofetch# system info
        fastfetch# system info

        wf-recorder
        wl-clipboard
        zip

        ; # zip compression
    };

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config = {
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  nix = {
    package = lib.mkDefault pkgs.nix;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
        "repl-flake"
      ];
      warn-dirty = false;
    };
  };

  programs = {
    home-manager.enable = true;
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
