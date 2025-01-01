{
  config,
  lib,
  pkgs,
  configMk,
  ...
}:
let
  inherit (lib) types mkIf mkEnableOption;
  inherit (configMk) mkOpt mkBoolOpt;
  # inherit (lib.${namespace}) mkBoolOpt mkOpt;

  cfg = config.system.fonts;
in
{
  options.system.fonts = with types; {
    enable = mkBoolOpt false "Whether or not to manage fonts.";
    fonts =
      with pkgs;
      mkOpt (listOf package) [
        # Desktop Fonts
        corefonts # MS fonts
        b612 # high legibility
        material-icons
        material-design-icons
        work-sans
        comic-neue
        source-sans
        inter
        lexend
        noto-fonts
        meslo-lgs-nf

        # Emojis
        noto-fonts-color-emoji
        twemoji-color-font

        # Nerd Fonts

        nerd-fonts.ubuntu
        nerd-fonts.ubuntu-mono
        nerd-fonts.caskaydia-cove
        nerd-fonts.fantasque-sans-mono
        nerd-fonts.fira-code
        nerd-fonts.mononoki

        nerd-fonts.caskaydia-cove
        nerd-fonts.iosevka
        nerd-fonts.monaspace
        nerd-fonts.symbols-only
      ] "Custom font packages to install.";
    # default = mkOpt types.str "FantasqueSansM Nerd Font" "Default font name";
  };

  config = mkIf cfg.enable {
    environment.variables = {
      # Enable icons in tooling since we have nerdfonts.
      LOG_ICONS = "true";
    };
  };
}
