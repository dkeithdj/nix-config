{
  description = "Den's Nix-Config";

  outputs =
    {
      self,
      nixpkgs,
      # nixpkgs-stable,
      # disko,
      home-manager,
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
        #"aarch64-darwin"
      ];

      # ========== Extend lib with lib.custom ==========
      # NOTE: This approach allows lib.custom to propagate into hm
      # see: https://github.com/nix-community/home-manager/pull/3454
      lib = nixpkgs.lib.extend (self: super: { custom = import ./lib { inherit (nixpkgs) lib; }; });

      # lib = nixpkgs.lib // home-manager.lib;
      # forEachSystem = f: lib.genAttrs (import systems) (system: f pkgsFor.${system});
      # pkgsFor = lib.genAttrs (import systems) (
      #   system:
      #   import nixpkgs {
      #     inherit system;
      #     config.allowUnfree = true;
      #   }
      # );
      # configVars = import ./vars { inherit inputs lib; };
      # configLib = import ./lib { inherit lib; };

      # TODO: make it so that ags will be in pkgs
      # ags = pkgsFor.x86_64-linux.callPackage ./home/denrei/common/optional/ags { inherit inputs; };
      # specialArgs = {
      #   inherit
      #     # ags
      #     inputs
      #     outputs
      #     configVars
      #     configLib
      #     ;
      # };
    in
    {
      # inherit (nixpkgs) lib;

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
      # darwinConfigurations = builtins.listToAttrs (
      #   map (host: {
      #     name = host;
      #     value = nix-darwin.lib.darwinSystem {
      #       specialArgs = {
      #         inherit inputs outputs lib;
      #         isDarwin = true;
      #       };
      #       modules = [ ./hosts/darwin/${host} ];
      #     };
      #   }) (builtins.attrNames (builtins.readDir ./hosts/darwin))
      # );

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
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-rfc-style);
      checks = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        import ./checks.nix { inherit inputs system pkgs; }
      );

      devShells = forAllSystems (
        system:
        import ./shell.nix {
          pkgs = nixpkgs.legacyPackages.${system};
          checks = self.checks.${system};
        }
      );

      # Custom modules to enable special functionality for nixos or home-manager oriented configs.
      # nixosModules = import ./modules/nixos;
      # homeManagerModules = import ./modules/home-manager;

      # overlays = import ./overlays { inherit inputs outputs; };
      # Custom modifications/overrides to upstream packages.
      # packages = forEachSystem (pkgs: import ./pkgs { inherit pkgs; });
      # devShells = forEachSystem (pkgs: import ./shell.nix { inherit pkgs; });
      # formatter = forEachSystem (pkgs: pkgs.alejandra);

      #################### NixOS Configurations ####################
      #
      # Building configurations available through `just rebuild` or `nixos-rebuild --flake .#hostname`

      # nixosConfigurations = {
      #   # Desktop PC
      #   altair = lib.nixosSystem {
      #     specialArgs = specialArgs;
      #     modules = [
      #       # nixos-cosmic.nixosModules.default
      #       lanzaboote.nixosModules.lanzaboote
      #       home-manager.nixosModules.home-manager
      #       { home-manager.extraSpecialArgs = specialArgs; }
      #       # { nixpkgs.overlays = [ inputs.hyprpanel.overlay ]; }
      #       ./hosts/altair
      #     ];
      #   };
      #   # HP Laptop
      #   canopus = lib.nixosSystem {
      #     specialArgs = specialArgs;
      #     modules = [
      #       kmonad.nixosModules.default
      #       home-manager.nixosModules.home-manager
      #       # {
      #       #   environment.systemPackages = [
      #       #     ghostty.packages.x86_64-linux.default
      #       #   ];
      #       # }
      #       { home-manager.extraSpecialArgs = specialArgs; }
      #       ./hosts/canopus
      #     ];
      #   };
      #   # QEMU VM
      #   polaris = lib.nixosSystem {
      #     specialArgs = specialArgs;
      #     modules = [
      #       inputs.disko.nixosModules.disko
      #       home-manager.nixosModules.home-manager
      #       { home-manager.extraSpecialArgs = specialArgs; }
      #       ./hosts/polaris
      #     ];
      #   };
      # };
      #################### Home Manager Configurations ####################
      # homeConfigurations = {
      #   # Desktop home
      #   "denrei@altair" = lib.homeManagerConfiguration {
      #     pkgs = import nixpkgs {
      #       system = "x86_64-linux";
      #       overlays = [
      #         inputs.hyprpanel.overlay
      #       ];
      #       config.allowUnfree = true;
      #     };
      #     extraSpecialArgs = specialArgs;
      #     modules = [
      #       ./home/denrei/altair.nix
      #       ./home/denrei/nixpkgs.nix
      #     ];
      #   };
      #   # HP Laptop home
      #   "denrei@canopus" = lib.homeManagerConfiguration {
      #     pkgs = import nixpkgs {
      #       system = "x86_64-linux";
      #       overlays = [
      #         inputs.hyprpanel.overlay
      #       ];
      #       config.allowUnfree = true;
      #     };
      #     extraSpecialArgs = specialArgs;
      #     modules = [
      #       ./home/denrei/canopus.nix
      #       ./home/denrei/nixpkgs.nix
      #     ];
      #   };
      #   # QEMU VM Home
      #   "denrei@polaris" = lib.homeManagerConfiguration {
      #     pkgs = pkgsFor.x86_64-linux;
      #     extraSpecialArgs = specialArgs;
      #     modules = [
      #       ./home/denrei/polaris.nix
      #       ./home/denrei/nixpkgs.nix
      #     ];
      #   };
      # };
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

    #################### Utilities ####################

    impermanence.url = "github:nix-community/impermanence";
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
    hyprland-hyprspace = {
      url = "github:KZDKM/Hyprspace";
      inputs.hyprland.follows = "hyprland";
    };

    matugen = {
      url = "github:InioX/matugen?ref=v2.2.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ags = {
      url = "github:Aylur/ags/v1.9.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    astal.url = "github:Aylur/astal";

    # ghostty = {
    #   url = "github:ghostty-org/ghostty";
    # };
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

    zen-browser.url = "github:0xc000022070/zen-browser-flake";

    wezterm.url = "github:wez/wezterm?dir=nix";
    #################### Personal Repositories ####################

    # Private secrets repo.  See ./docs/secretsmgmt.md
    # Authenticate via ssh and use shallow clone
    nix-secrets = {
      url = "git+ssh://git@github.com/dkeithdj/nix-secrets.git?ref=main&shallow=1";
      flake = false;
    };

    #################### Firefox ####################
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    #################### Secure Boot ####################
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
      # Optional but recommended to limit the size of your system closure.
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # #################### Zed ####################
    zed-editor.url = "github:zed-industries/zed/nightly";
  };
}
