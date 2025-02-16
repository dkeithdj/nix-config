# *.nix
{
  inputs,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    types
    mkIf
    mkOption
    mkEnableOption
    ;

in
# Shorthand lambda for self-documenting options under settings
{
  imports = [ inputs.hyprpanel.homeManagerModules.hyprpanel ];

  home.packages = with pkgs; [
    rofi
  ];

  programs.hyprpanel = {
    overlay.enable = true;

    # Enable the module.
    # Default: false
    enable = true;

    # Automatically restart HyprPanel with systemd.
    # Useful when updating your config so that you
    # don't need to manually restart it.
    # Default: false
    # systemd.enable = true;

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
          middle = [
            "clock"
            "media"
          ];
          right =
            [
              "ram"
              "volume"
              "network"
              "systray"
              "notifications"
            ]
            ++ (if (builtins.getEnv "PC" != "1") then [ "battery" ] else [ ])
            ++ [
              "power"
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
      bar.clock.format = "%a %b %d  %H:%M";
      bar.customModules.ram.labelType = "used/total";
      bar.launcher.autoDetectIcon = true;
      bar.workspaces.show_icons = true;
      bar.workspaces.show_numbered = true;
      bar.workspaces.workspaces = 7;
      menus.clock = {
        time = {
          military = true;
          hideSeconds = true;
        };
        weather.enabled = false;
        weather.unit = "metric";
      };

      menus.dashboard.directories.enabled = false;
      menus.dashboard.stats.enable_gpu = false;
      menus.dashboard.shortcuts.left.shortcut1.command = "zen";
      menus.dashboard.shortcuts.left.shortcut1.icon = "󰖟";
      menus.dashboard.shortcuts.left.shortcut1.tooltip = "Browser";
      menus.dashboard.shortcuts.left.shortcut2.command = "spotify";
      menus.dashboard.shortcuts.left.shortcut2.icon = "󰓇";
      menus.dashboard.shortcuts.left.shortcut2.tooltip = "Spotify";
      menus.dashboard.shortcuts.left.shortcut3.command = "vencord";
      menus.dashboard.shortcuts.left.shortcut3.icon = "";
      menus.dashboard.shortcuts.left.shortcut3.tooltip = "Discord";
      menus.dashboard.shortcuts.left.shortcut4.command = "rofi -show drun";
      menus.dashboard.shortcuts.left.shortcut4.icon = "";
      menus.dashboard.shortcuts.left.shortcut4.tooltip = "Search Apps";

      theme.bar.outer_spacing = "0.5em";
      theme.bar.transparent = false;
      theme.bar.border.width = "0em";
      theme.bar.border_radius = "1em";
      theme.bar.buttons.background_hover_opacity = 60;

      theme.font = {
        name = "Ubuntu Nerd Font Propo";
        size = "1.0rem";
      };
    };
  };

}
