{ lib, pkgs, ... }:
{
  services.ollama = {
    enable = true;
    # package = pkgs.ollama-rocm;
    # acceleration = "rocm";
    # environmentVariables = {
    #   HCC_AMDGPU_TARGET = "gfx1031"; # used to be necessary, but doesn't seem to anymore
    # };
    # rocmOverrideGfx = "10.3.1";
  };

}
