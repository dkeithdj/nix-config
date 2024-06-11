{
  description = "EmergentMind's Nix-Config";

  inputs = {
    #################### Official NixOS and HM Package Sources ####################

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/release-24.05"; # also see 'unstable-packages' overlay at 'overlays/default.nix"

    hardware.url = "github:nixos/nixos-hardware";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
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

    # Windows management
    # for now trying to avoid this one because I want stability for my wm
    # this is the hyprland development flake package / unstable
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    # Hyprland
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    #################### Personal Repositories ####################

    # Private secrets repo.  See ./docs/secretsmgmt.md
    # Authenticate via ssh and use shallow clone
    nix-secrets = {
      url = "git+ssh://git@github.com/dkeithdj/nix-secrets.git?ref=main&shallow=1";
      flake = false;
    };
  };

  outputs = { self, disko, nixpkgs, home-manager, ... } @ inputs:
    let
      inherit (self) outputs;
      forAllSystems = nixpkgs.lib.genAttrs [
        "x86_64-linux"
        #"aarch64-darwin"
      ];
      inherit (nixpkgs) lib;
      configVars = import ./vars { inherit inputs lib; };
      configLib = import ./lib { inherit lib; };
      specialArgs = { inherit inputs outputs configVars configLib nixpkgs; };
    in
    {
      # Custom modules to enable special functionality for nixos or home-manager oriented configs.
      nixosModules = import ./modules/nixos;
      homeManagerModules = import ./modules/home-manager;

      # Custom modifications/overrides to upstream packages.
      overlays = import ./overlays { inherit inputs outputs; };

      # Custom packages to be shared or upstreamed.
      packages = forAllSystems
        (system:
          let pkgs = nixpkgs.legacyPackages.${system};
          in import ./pkgs { inherit pkgs; }
        );

      # TODO change this to something that has better looking output rules
      # Nix formatter available through 'nix fmt' https://nix-community.github.io/nixpkgs-fmt
      formatter = forAllSystems
        (system:
          nixpkgs.legacyPackages.${system}.nixpkgs-fmt
        );

      # Shell configured with packages that are typically only needed when working on or with nix-config.
      devShells = forAllSystems
        (system:
          let pkgs = nixpkgs.legacyPackages.${system};
          in import ./shell.nix { inherit pkgs; }
        );

      #################### NixOS Configurations ####################
      #
      # Building configurations available through `just rebuild` or `nixos-rebuild --flake .#hostname`

      nixosConfigurations = {
        # Desktop PC
        # altair = lib.nixosSystem {
        #   inherit specialArgs;
        #   modules = [
        #     home-manager.nixosModules.home-manager
        #     {
        #       home-manager.extraSpecialArgs = specialArgs;
        #     }
        #     ./hosts/altair
        #   ];
        # };
        # # HP Laptop
        # canopus = lib.nixosSystem {
        #   inherit specialArgs;
        #   modules = [
        #     home-manager.nixosModules.home-manager
        #     {
        #       home-manager.extraSpecialArgs = specialArgs;
        #     }
        #     ./hosts/canopus
        #   ];
        # };
        # QEMU VM
        polaris = lib.nixosSystem {
          inherit specialArgs;
          modules = [
            home-manager.nixosModules.home-manager
            {
              home-manager.extraSpecialArgs = specialArgs;
            }
            ./hosts/polaris
          ];
        };
      };
    };
}
