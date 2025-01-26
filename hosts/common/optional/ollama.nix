{ lib, pkgs, ... }:
{
  services.ollama = {
    enable = true;
    package = pkgs.stable.ollama-rocm;
    acceleration = "rocm";
    environmentVariables = {
      HCC_AMDGPU_TARGET = "gfx1032"; # used to be necessary, but doesn't seem to anymore
    };
    rocmOverrideGfx = "10.3.2";
  };

}
