{
  lib,
  pkgs,
  config,
  namespace,
  inputs,
  ...
}:
with lib;
with lib.${namespace}; {
  imports = [
    ./hardware-configuration.nix
    inputs.disko.nixosModules.disko
    ./laptop-disk-config.nix
    {
      _module.args = {
        disk = [
          "/dev/nvme0n1"
          "/dev/sda"
        ];
        withSwap = true;
        swapSize = "8";
      };
    }
  ];

  cih = {
    apps = {
      hey = enabled;
      zoom-us = enabled;
    };
    system = {
      boot = enabled;
    };
  };

  system.stateVersion = "24.05";
}
