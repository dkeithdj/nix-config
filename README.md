# My Nix-Config

## Structure

- `flake.nix` - Entrypoint for hosts and user home configurations
- `hosts` - NixOS configurations accessible via `sudo nixos-rebuild switch --flake .#<host>`.
  - `common` - Shared configurations consumed by the machine specific ones.
    - `core` - Configurations present across all hosts. This is a hard rule! If something isn't core, it is optional.
    - `disks` - Declarative disk partition and format specifications via disko.
    - `optional` - Optional configurations present across more than one host.
    - `users` - Host level user configurations present across at least one host.
  - `altair` - Destop PC (not fully configured yet)
  - `canopus` - HP Laptop
  - `polaris` - Qemu VM Sandbox
- `home/<user>` - Home-manager configurations, built automatically during host rebuilds.
  - `common` - shared home-manager configurations consumed the user's machine specific ones.
    - `core` - Home-manager configurations present for user across all machines. This is a hard rule! If something isn't core, it is optional.
    - `optional` - Optional home-manager configurations that can be added for specific machines.
      The home-manager core and options are defined in host-specific .nix files housed in `home/<user>`.
- `lib` - Custom library used throughout the nix-config to make import paths more readable.
- `modules` - Custom modules to enable special functionality for nixos or home-manager oriented configurations.
- `nixos-installer` - A stripped down version of the main nix-config flake used exclusively for generating ISOs and during installation of NixOS and nix-config on hosts.
- `overlays` - Custom modifications to upstream packages.
- `pkgs` - Custom packages meant to be shared or upstreamed.
- `vars` - Custom variables used throughout the nix-config. Most of the variables are focused on the primary user across all hosts.
- `scripts` - Custom scripts for automation, including remote installation and bootstrapping of NixOS and nix-config.

## Secrets Management

Secrets for this config are stored in a private repository called nix-secrets that is pulled in as a flake input and managed using the sops-nix tool.

## Support

## Heavily inspired by these awesome people

- [EmergentMind](https://github.com/EmergentMind)
- [Misterio77](https://github.com/Misterio77)
- [Aylur](https://github.com/Aylur)
