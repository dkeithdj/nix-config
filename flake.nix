{
  description = "Den's Nix-Config";

  inputs = {
    #################### Official NixOS and HM Package Sources ####################

    # nixpkgs.url = "github:NixOS/nixpkgs/release-24.05";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/release-24.05"; # also see 'stable-packages' overlay at 'overlays/default.nix"

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
      url = "github:Aylur/ags";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    astal.url = "github:Aylur/astal";

    lf-icons = {
      url = "github:gokcehan/lf";
      flake = false;
    };

    firefox-gnome-theme = {
      url = "github:rafaelmardojai/firefox-gnome-theme";
      flake = false;
    };

    nur.url = "github:nix-community/NUR"; # AUR for nix

    kmonad = {
      url = "git+https://github.com/kmonad/kmonad?submodules=1&dir=nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
      url = "github:nix-community/lanzaboote/v0.4.1";
      # Optional but recommended to limit the size of your system closure.
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs @
    { self
    , disko
    , nixpkgs
    , home-manager
    , systems
    , kmonad
    , lanzaboote
    , ...
    }:
    let
      inherit (self) outputs;

      lib = nixpkgs.lib // home-manager.lib;
      forEachSystem = f: lib.genAttrs (import systems) (system: f pkgsFor.${system});
      pkgsFor = lib.genAttrs (import systems) (
        system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        }
      );
      configVars = import ./vars { inherit inputs lib; };
      configLib = import ./lib { inherit lib; };

      # TODO: make it so that ags will be in pkgs
      ags = pkgsFor.x86_64-linux.callPackage ./home/denrei/common/optional/ags { inherit inputs; };
      specialArgs = {
        inherit
          ags
          inputs
          outputs
          configVars
          configLib
          ;
      };

    in
    {
      inherit (nixpkgs) lib;
      # Custom modules to enable special functionality for nixos or home-manager oriented configs.
      nixosModules = import ./modules/nixos;
      homeManagerModules = import ./modules/home-manager;


      overlays = import ./overlays { inherit inputs outputs; };
      # Custom modifications/overrides to upstream packages.
      packages = forEachSystem (pkgs: import ./pkgs { inherit pkgs; });
      devShells = forEachSystem (pkgs: import ./shell.nix { inherit pkgs; });
      formatter = forEachSystem (pkgs: pkgs.alejandra);

      #################### NixOS Configurations ####################
      #
      # Building configurations available through `just rebuild` or `nixos-rebuild --flake .#hostname`

      nixosConfigurations = {
        # Desktop PC
        altair = lib.nixosSystem {
          specialArgs = specialArgs;
          modules = [
            lanzaboote.nixosModules.lanzaboote
            home-manager.nixosModules.home-manager
            { home-manager.extraSpecialArgs = specialArgs; }
            ./hosts/altair
          ];
        };
        # HP Laptop
        canopus = lib.nixosSystem {
          specialArgs = specialArgs;
          modules = [
            kmonad.nixosModules.default
            lanzaboote.nixosModules.lanzaboote
            home-manager.nixosModules.home-manager
            { home-manager.extraSpecialArgs = specialArgs; }
            ./hosts/canopus
          ];
        };
        # QEMU VM
        polaris = lib.nixosSystem {
          specialArgs = specialArgs;
          modules = [
            inputs.disko.nixosModules.disko
            home-manager.nixosModules.home-manager
            { home-manager.extraSpecialArgs = specialArgs; }
            ./hosts/polaris
          ];
        };
      };
      #################### Home Manager Configurations ####################
      homeConfigurations = {
        # Desktop home
        "denrei@altair" = lib.homeManagerConfiguration {
          pkgs = pkgsFor.x86_64-linux;
          extraSpecialArgs = specialArgs;
          modules = [
            ./home/denrei/altair.nix
            ./home/denrei/nixpkgs.nix
          ];
        };
        # HP Laptop home
        "denrei@canopus" = lib.homeManagerConfiguration {
          pkgs = pkgsFor.x86_64-linux;
          extraSpecialArgs = specialArgs;
          modules = [
            ./home/denrei/canopus.nix
            ./home/denrei/nixpkgs.nix
          ];
        };
        # QEMU VM Home
        "denrei@polaris" = lib.homeManagerConfiguration {
          pkgs = pkgsFor.x86_64-linux;
          extraSpecialArgs = specialArgs;
          modules = [
            ./home/denrei/polaris.nix
            ./home/denrei/nixpkgs.nix
          ];
        };
      };
    };
}
