{
  description = "Den's Nix-Config";

  outputs =
    {
      self,
      nixpkgs,
      nix-darwin,
      treefmt-nix,
      # nixpkgs-stable,
      # disko,
      # systems,
      # kmonad,
      # lanzaboote,
      # nixos-cosmic,
      # zen-browser,
      # ghostty,
      # zed-editor,
      ...
    }@inputs:
    let
      inherit (self) outputs;

      forAllSystems = nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "aarch64-darwin"
      ];

      # ========== Extend lib with lib.custom ==========
      # NOTE: This approach allows lib.custom to propagate into hm
      # see: https://github.com/nix-community/home-manager/pull/3454
      lib = nixpkgs.lib.extend (_self: _super: { custom = import ./lib { inherit (nixpkgs) lib; }; });
      forEachSystem = f: forAllSystems (system: f nixpkgs.legacyPackages.${system});

      treefmtEval = forEachSystem (pkgs: treefmt-nix.lib.evalModule pkgs ./treefmt.nix);
      # pkgsFor = lib.genAttrs (import systems) (
      #   system:
      #   import nixpkgs {
      #     inherit system;
      #     config.allowUnfree = true;
      #   }
      # );

    in
    {

      # ========= Overlays =========
      #
      # Custom modifications/overrides to upstream packages.
      overlays = import ./overlays { inherit inputs; };

      # ========= Host Configurations =========
      #
      # Building configurations is available through `just rebuild` or `nixos-rebuild --flake .#hostname`
      nixosConfigurations = builtins.listToAttrs (
        map (host: {
          name = host;
          value = nixpkgs.lib.nixosSystem {
            specialArgs = {
              inherit inputs outputs lib;
              isDarwin = false;
            };
            modules = [ ./hosts/nixos/${host} ];
          };
        }) (builtins.attrNames (builtins.readDir ./hosts/nixos))
      );
      darwinConfigurations = builtins.listToAttrs (
        map (host: {
          name = host;
          value = nix-darwin.lib.darwinSystem {
            specialArgs = {
              inherit inputs outputs lib;
              isDarwin = true;
            };
            modules = [ ./hosts/darwin/${host} ];
          };
        }) (builtins.attrNames (builtins.readDir ./hosts/darwin))
      );

      # ========= Packages =========
      #
      # Add custom packages to be shared or upstreamed.
      packages = forAllSystems (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ self.overlays.default ];
          };
        in
        nixpkgs.lib.packagesFromDirectoryRecursive {
          callPackage = nixpkgs.lib.callPackageWith pkgs;
          directory = ./pkgs/common;
        }
      );

      # ========= Formatting =========
      #
      # Nix formatter available through 'nix fmt' https://github.com/NixOS/nixfmt
      # formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-rfc-style);
      formatter = forEachSystem (pkgs: treefmtEval.${pkgs.system}.config.build.wrapper);
      checks = forEachSystem (pkgs: {
        formatting = treefmtEval.${pkgs.system}.config.build.check self;
      });
      # checks = forAllSystems (
      #   system:
      #   let
      #     pkgs = nixpkgs.legacyPackages.${system};
      #   in
      #   # import ./checks.nix { inherit inputs system pkgs; }
      #   {
      #     formatting = treefmtEval.${pkgs.system}.config.build.check self;
      #   }
      # );

      devShells = forAllSystems (
        system:
        import ./shell.nix {
          pkgs = nixpkgs.legacyPackages.${system};
          checks = self.checks.${system};
        }
      );
    };

  inputs = {
    #################### Official NixOS and HM Package Sources ####################

    # nixpkgs.url = "github:NixOS/nixpkgs/release-24.05";
    nixpkgs.url = "git+https://github.com/NixOS/nixpkgs?shallow=1&ref=nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/release-24.11"; # also see 'stable-packages' overlay at 'overlays/default.nix"

    hardware.url = "github:nixos/nixos-hardware";
    systems.url = "github:nix-systems/default-linux";

    home-manager = {
      url = "github:nix-community/home-manager"; # unstable
      # url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew = {
      url = "github:zhaofengli-wip/nix-homebrew";
    };
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };

    #################### Utilities ####################

    # impermanence.url = "github:nix-community/impermanence";
    # Declarative partitioning and formatting
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Secrets management. See ./docs/secretsmgmt.md
    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    # Hyprland
    # Windows management
    # for now trying to avoid this one because I want stability for my wm
    # this is the hyprland development flake package / unstable
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    # hyprland-hyprspace = {
    #   url = "github:KZDKM/Hyprspace";
    #   inputs.hyprland.follows = "hyprland";
    # };

    matugen = {
      url = "github:InioX/matugen?ref=v2.2.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ags = {
      url = "github:Aylur/ags/v1.9.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    astal.url = "github:Aylur/astal";

    ghostty = {
      url = "github:ghostty-org/ghostty";
    };

    lf-icons = {
      url = "github:gokcehan/lf";
      flake = false;
    };

    # hyprpanel = {
    #   url = "github:jas-singhfsu/hyprpanel";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    firefox-gnome-theme = {
      url = "github:rafaelmardojai/firefox-gnome-theme";
      flake = false;
    };

    nur.url = "github:nix-community/NUR"; # AUR for nix

    kmonad = {
      url = "github:kmonad/kmonad?dir=nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Pre-commit
    pre-commit-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nixos-cosmic = {
    #   url = "github:lilyinstarlight/nixos-cosmic";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser.url = "github:0xc000022070/zen-browser-flake";

    wezterm.url = "github:wez/wezterm?dir=nix";
    #################### Personal Repositories ####################

    # Private secrets repo.  See ./docs/secretsmgmt.md
    # Authenticate via ssh and use shallow clone
    nix-secrets = {
      url = "git+ssh://git@github.com/dkeithdj/nix-secrets.git?ref=main&shallow=1";
      # flake = false;
      inputs = { };
    };

    #################### Firefox ####################
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # aagl.url = "github:ezKEa/aagl-gtk-on-nix";
    ##################### Secure Boot ####################
    #lanzaboote = {
    #  url = "github:nix-community/lanzaboote/v0.4.2";
    #  # Optional but recommended to limit the size of your system closure.
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};

    # #################### Zed ####################
    # zed-editor.url = "github:zed-industries/zed/nightly";
  };
}
