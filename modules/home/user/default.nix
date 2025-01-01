{
  config,
  lib,
  pkgs,
  outputs,
  inputs,
  configLib,
  configMk,
  ...
}:
let

  inherit (lib)
    hm
    types
    strings
    mkIf
    mkDefault
    mkMerge
    getExe
    getExe'
    ;
  inherit (configMk) mkOpt enabled;

  cfg = config.user;

  home-directory =
    if cfg.name == null then
      null
    else if pkgs.stdenv.isDarwin then
      "/Users/${cfg.name}"
    else
      "/home/${cfg.name}";

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

  projectCreate = strings.concatMapStringsSep " " (
    x: "mkdir -p ${config.user.home}/Projects/" + x + "\n"
  ) projectFiles;
  homeCreate = strings.concatMapStringsSep " " (
    x: "mkdir -p ${config.user.home}/" + x + "\n"
  ) homeFiles;
in
{
  options.user = {
    enable = mkOpt types.bool false "Whether to configure the user account.";
    # email = mkOpt types.str "khaneliman12@gmail.com" "The email of the user.";
    fullName = mkOpt types.str "Denrei Keith" "The full name of the user.";
    home = mkOpt (types.nullOr types.str) home-directory "The user's home directory.";
    # icon =
    #   mkOpt (types.nullOr types.package) pkgs.${namespace}.user-icon
    #     "The profile picture to use for the user.";
    name = mkOpt (types.nullOr types.str) "denrei" "The user account.";
  };

  # imports = (configLib.scanPaths ./.) ++ (builtins.attrValues outputs.homeManagerModules);
  # ++ [ inputs.impermanence.nixosModules.home-manager.impermanence ];

  config = mkIf cfg.enable (mkMerge [
    {
      assertions = [
        {
          assertion = cfg.name != null;
          message = "user.name must be set";
        }
        {
          assertion = cfg.home != null;
          message = "user.home must be set";
        }
      ];

      home = {
        username = mkDefault cfg.name;
        homeDirectory = mkDefault cfg.home;
        stateVersion = config.system.stateVersion;
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
          GOPATH = "${cfg.home}/.local/share/go";
          GOMODCACHE = "${cfg.home}/.cache/go/pkg/mod";
        };
        activation = {
          home = hm.dag.entryAfter [ "writeBoundary" ] homeCreate;
          projects = hm.dag.entryAfter [ "writeBoundary" ] projectCreate;
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
          home = cfg.home;
        in
        builtins.map (x: "file://${home}/" + x) homeFiles;

      #TODO: Move
      services = {
        kdeconnect = {
          enable = true;
          indicator = true;
        };
      };

    }
  ]);
  services.ssh-agent.enable = true;

  #TODO: flake
  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config = {
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  #TODO: shared/nix
  nix = {
    package = mkDefault pkgs.nix;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      warn-dirty = false;
    };
  };

  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
