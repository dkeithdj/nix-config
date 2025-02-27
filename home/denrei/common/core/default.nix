{
  config,
  lib,
  pkgs,
  outputs,
  inputs,
  configLib,
  ...
}:
let
  homeFiles = [
    "Documents"
    "Music"
    "Pictures"
    "Videos"
    "Downloads"
    "Desktop"
    "Projects"
  ];
  projectFiles = [
    "nix"
    "work"
    "school"
    "web"
    "blogs"
  ];

  projectCreate = lib.strings.concatMapStringsSep " " (
    x: "mkdir -p ${config.home.homeDirectory}/Projects/" + x + "\n"
  ) projectFiles;
  homeCreate = lib.strings.concatMapStringsSep " " (
    x: "mkdir -p ${config.home.homeDirectory}/" + x + "\n"
  ) homeFiles;
in
{
  imports = (configLib.scanPaths ./.) ++ (builtins.attrValues outputs.homeManagerModules);
  # ++ [ inputs.impermanence.nixosModules.home-manager.impermanence ];

  services.ssh-agent.enable = true;

  home = {
    username = lib.mkDefault "denrei";
    homeDirectory = lib.mkDefault "/home/${config.home.username}";
    stateVersion = lib.mkDefault "24.05";
    sessionPath = [
      "$HOME/.local/bin"
      "$HOME/.avm/bin"
      "$HOME/.cargo/bin"
      "$HOME/.local/share/solana/install/active_release/bin"
    ];
    sessionVariables = {
      DIRENV_LOG_FORMAT = "";
      PROJECTS = "$HOME/Projects";
      FLAKE = "$HOME/Projects/nix-config";
      QT_XCB_GL_INTEGRATION = "none"; # kde-connect
      NIXPKGS_ALLOW_UNFREE = "1";
      NIXPKGS_ALLOW_INSECURE = "1";
      BROWSER = "zen";
      SHELL = "zsh";
      TERM = "xterm-256color";
      TERMINAL = "wezterm";
      EDITOR = "nvim";
      # MANPAGER = "batman";
      # BAT_THEME = "base16";
      GOPATH = "${config.home.homeDirectory}/.local/share/go";
      GOMODCACHE = "${config.home.homeDirectory}/.cache/go/pkg/mod";
    };
    activation = {
      home = lib.hm.dag.entryAfter [ "writeBoundary" ] homeCreate;
      projects = lib.hm.dag.entryAfter [ "writeBoundary" ] projectCreate;
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
    builtins.map (x: "file://${home}/" + x) homeFiles;
  services = {
    kdeconnect = {
      enable = true;
      indicator = true;
    };
  };

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
    gh # github cli
    jq # JSON pretty printer and manipulator
    lazygit # git TUI
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
    bun
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
    # qmk
    # qmk_hid

    viu
    chafa
    ueberzugpp
    aws-sam-cli

    devenv
  ];

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
