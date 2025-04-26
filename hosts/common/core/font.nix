{
  pkgs,
  lib,
  isDarwin,
  ...
}:
{
  fonts =
    {
      packages = with pkgs.nerd-fonts; [
        ubuntu
        ubuntu-mono
        fantasque-sans-mono
        jetbrains-mono
        fira-mono
      ];
    }
    // lib.optionalAttrs (!isDarwin) {
      fontconfig.enable = true;
    };
}
