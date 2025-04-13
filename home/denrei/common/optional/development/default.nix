{ pkgs, ... }:
{
  home.packages = builtins.attrValues {
    inherit (pkgs)
      neovide
      postman
      ;
  };
}
