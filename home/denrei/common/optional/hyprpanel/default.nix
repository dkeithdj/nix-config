# *.nix
{ inputs, lib, ... }:
let
  inherit (lib)
    types
    mkIf
    mkOption
    mkEnableOption
    ;
  # Shorthand lambda for self-documenting options under settings
  mkStrOption =
    default:
    mkOption {
      type = types.str;
      default = default;
    };
  mkIntOption =
    default:
    mkOption {
      type = types.int;
      default = default;
    };
  mkBoolOption =
    default:
    mkOption {
      type = types.bool;
      default = default;
    };
  mkStrListOption =
    default:
    mkOption {
      type = types.listOf types.str;
      default = default;
    };
  mkFloatOption =
    default:
    mkOption {
      type = types.float;
      default = default;
    };
in
{
  imports = [ inputs.hyprpanel.homeManagerModules.hyprpanel ];

  programs.hyprpanel = {
    overlay.enable = true;

    # Enable the module.
    # Default: false
    enable = true;

    # Automatically restart HyprPanel with systemd.
    # Useful when updating your config so that you
    # don't need to manually restart it.
    # Default: false
    systemd.enable = true;

    # Add '/nix/store/.../hyprpanel' to your
    # Hyprland config 'exec-once'.
    # Default: false
    hyprland.enable = true;

    # Fix the overwrite issue with HyprPanel.
    # See below for more information.
    # Default: false
    overwrite.enable = true;

    # Import a theme from './themes/*.json'.
    # Default: ""
    # theme = "gruvbox_split";

    # Override the final config with an arbitrary set.
    # Useful for overriding colors in your selected theme.
    # Default: {}
    # override = {
    #   theme.bar.menus.text = "#123ABC";
    # };

    # Configure bar layouts for monitors.
    # See 'https://hyprpanel.com/configuration/panel.html'.
    # Default: null
    layout = {
      "bar.layouts" = {
        "0" = {
          left = [
            "dashboard"
            "workspaces"
            "windowtitle"
          ];
          middle = [ "media" ];
          right = [
            "volume"
            "network"
            "bluetooth"
            "battery"
            "systray"
            "clock"
            "notifications"
          ];
        };
      };
    };

    # Configure and theme almost all options from the GUI.
    # Options that require '{}' or '[]' are not yet implemented,
    # except for the layout above.
    # See 'https://hyprpanel.com/configuration/settings.html'.
    # Default: <same as gui>
    settings = {
      bar.launcher.autoDetectIcon = true;
      bar.workspaces.show_icons = true;
      bar.clock.format = "%a %b %d  %I:%M:%S %p";
      bar.clock.icon = "󰸗";
      bar.clock.middleClick = "";
      bar.clock.rightClick = "";
      bar.clock.scrollDown = "";
      bar.clock.scrollUp = "";
      bar.clock.showIcon = true;
      bar.clock.showTime = true;

      menus.clock = {
        time = {
          military = true;
          hideSeconds = true;
        };
        # weather.unit = "metric";
      };

      menus.dashboard.directories.enabled = false;
      menus.dashboard.stats.enable_gpu = false;

      theme.bar.transparent = true;

      theme.font = {
        name = "Ubuntu Nerd Font Regular";
        size = "1.0rem";
      };
    };
  };
}
