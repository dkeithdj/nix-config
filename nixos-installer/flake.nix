{
  description = "Minimal NixOS configuration for bootstrapping systems";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # Declarative partitioning and formatting
    disko.url = "github:nix-community/disko";
  };

  outputs =
    {
      self,
      nixpkgs,
      ...
    }@inputs:
    let
      inherit (self) outputs;

      minimalSpecialArgs = {
        inherit inputs outputs;
        lib = nixpkgs.lib.extend (_self: _super: { custom = import ../lib { inherit (nixpkgs) lib; }; });
      };

      # FIXME: Specify arch eventually probably
      # This mkHost is way better: https://github.com/linyinfeng/dotfiles/blob/8785bdb188504cfda3daae9c3f70a6935e35c4df/flake/hosts.nix#L358
      newConfig =
        name: disk: withSwap: swapSize: diskConfig:
        (nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = minimalSpecialArgs;
          modules = [
            inputs.disko.nixosModules.disko
            "../hosts/common/disks/${diskConfig}.nix"
            {
              _module.args = {
                inherit disk withSwap swapSize;
              };
            }
            ./minimal-configuration.nix
            ../hosts/nixos/${name}/hardware-configuration.nix
            {
              networking.hostName = name;
            }
          ];
        });
    in
    {
      nixosConfigurations = {
        # host = newConfig "name" disk" "withSwap" "swapSize" "diskConfig"
        # Swap size is in GiB
        # altair = newConfig "altair" "/dev/nvme1n1" false "0" "btrfs-disk";
        canopus = newConfig "canopus" [ "/dev/nvme0n1" "/dev/sda" ] true "8" "laptop-disk-config";
        polaris = newConfig "polaris" "/dev/vda" false "0" "standard-disk-config";

        # Custom ISO
        #
        # `just iso` - from nix-config directory to generate the iso standalone
        # 'just iso-install <drive>` - from nix-config directory to generate and copy directly to USB drive
        # `nix build ./nixos-installer#nixosConfigurations.iso.config.system.build.isoImage` - from nix-config directory to generate the iso manually
        #
        # Generated images will be output to the ~/nix-config/results directory unless drive is specified
        # iso = nixpkgs.lib.nixosSystem {
        #   specialArgs = minimalSpecialArgs;
        #   modules = [
        #     "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
        #     "${nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix"
        #     ./iso
        #   ];
        # };
        altair = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = minimalSpecialArgs;
          modules = [
            inputs.disko.nixosModules.disko
            ../hosts/common/disks/altair.nix
            ./minimal-configuration.nix
            { networking.hostName = "altair"; }
            ../hosts/nixos/altair/hardware-configuration.nix
          ];
        };
      };
    };
}
