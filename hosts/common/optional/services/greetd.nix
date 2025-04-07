#
# greeter -> tuigreet https://github.com/apognu/tuigreet?tab=readme-ov-file
# display manager -> greetd https://man.sr.ht/~kennylevinsen/greetd/
#
{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.autoLogin;
in
{
  # Declare custom options for conditionally enabling auto login
  options.autoLogin = {
    enable = lib.mkEnableOption "Enable automatic login";

    username = lib.mkOption {
      type = lib.types.str;
      default = "guest";
      description = "User to automatically login";
    };
  };

  config = {
    environment.systemPackages = with pkgs; [ greetd.tuigreet ];

    services.greetd = {
      enable = true;

      restart = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --asterisks --time --time-format '%I:%M %p | %a • %h | %F' --cmd Hyprland";
          user = "denrei";
        };

        initial_session = lib.mkIf cfg.enable {
          command = "${pkgs.hyprland}/bin/Hyprland";
          user = "${cfg.username}";
        };
      };
    };
    # services.greetd = {
    #   enable = true;
    #   restart = true;
    #   settings = {
    #     default_session = {
    #       command = pkgs.writeShellScript "greeter" ''
    #         export XKB_DEFAULT_LAYOUT=${config.services.xserver.xkb.layout}
    #         export XCURSOR_THEME=Qogir
    #         ${ags}/bin/greeter
    #       '';
    #     };
    #     initial_session = lib.mkIf cfg.enable {
    #       command = "${pkgs.hyprland}/bin/Hyprland";
    #       user = "${cfg.username}";
    #     };
    #   };
    # };

    # systemd.tmpfiles.rules = [
    #   "d '/var/cache/greeter' - greeter greeter - -"
    # ];

    # system.activationScripts.wallpaper =
    #   let
    #     wp = pkgs.writeShellScript "wp" ''
    #       CACHE="/var/cache/greeter"
    #       OPTS="$CACHE/options.json"
    #       HOME="/home/$(find /home -maxdepth 1 -printf '%f\n' | tail -n 1)"
    #
    #       mkdir -p "$CACHE"
    #       chown greeter:greeter $CACHE
    #
    #       if [[ -f "$HOME/.cache/ags/options.json" ]]; then
    #         cp $HOME/.cache/ags/options.json $OPTS
    #         chown greeter:greeter $OPTS
    #       fi
    #
    #       if [[ -f "$HOME/.config/background" ]]; then
    #         cp "$HOME/.config/background" $CACHE/background
    #         chown greeter:greeter "$CACHE/background"
    #       fi
    #     '';
    #   in
    #   builtins.readFile wp;
  };
}
