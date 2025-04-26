{
  pkgs,
  config,
  lib,
  ...
}:
{
  imports = [
    ./binds.nix
  ];

  xdg.desktopEntries."org.gnome.Settings" = {
    name = "Settings";
    comment = "Gnome Control Center";
    icon = "org.gnome.Settings";
    exec = "env XDG_CURRENT_DESKTOP=gnome ${pkgs.gnome-control-center}/bin/gnome-control-center";
    categories = [ "X-Preferences" ];
    terminal = false;
  };

  # home.packages = [
  #   inputs.hyprland-contrib.packages.${pkgs.system}.grimblast # or any other package
  # ];

  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;
    # systemd.enable = true;
    xwayland.enable = true;
    plugins = [
      # inputs.hyprland-hyprspace.packages.${pkgs.system}.default
      # plugins.hyprexpo
      # plugins.hyprbars
      # plugins.borderspp
    ];

    settings = {
      env = [
        "NIXOS_OZONE_WL, 1" # for ozone-based and electron apps to run on wayland
        "MOZ_ENABLE_WAYLAND, 1" # for firefox to run on wayland
        "MOZ_WEBRENDER, 1" # for firefox to run on wayland
        "XDG_SESSION_TYPE, wayland"
        "WLR_NO_HARDWARE_CURSORS, 1"
        "WLR_RENDERER_ALLOW_SOFTWARE, 1"
        # "QT_QPA_PLATFORM,wayland"
      ];
      exec-once = [
        # "hyprpanel"
        "ags -b hypr"
        "hyprctl setcursor Qogir 24"
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "wl-paste --type image --watch cliphist store" # Stores only image data
        "wl-paste --type text --watch cliphist store" # Stores only image data
        # "transmission-gtk"
      ];

      # parse the monitor spec defined in nix-config/home/<user>/<host>.nix
      monitor = (
        map (
          m:
          "${m.name},${
            if m.enabled then
              "${toString m.width}x${toString m.height}@${toString m.refreshRate}"
              + ",${toString m.x}x${toString m.y},1"
              + ",transform,${toString m.transform}"
              + ",vrr,${toString m.vrr}"
            else
              "disable"
          }"
        ) (config.monitors)
      );

      # monitor = [
      # "eDP-1, 1920x1080, 0x0, 1"
      # "HDMI-A-1, 2560x1440, 1920x0, 1"
      #   "DP-2, 2560x1440@75.00Hz, 0x0, 1"
      # ];
      workspace = (
        let
          workspaceIDs = lib.flatten [
            (lib.range 0 9) # workspaces 0 through 9
            "special" # add the special/scratchpad ws
          ];
        in
        # workspace structure to build "[workspace], monitor:[name], default:[bool], persistent:[bool]"
        map (
          ws:
          # map over workspace IDs first, then map over monitors to check for entries, and contact the empty
          # string elements created for ws and m combinations that don't match our actual conditions
          lib.concatMapStrings (
            m:
            # workspaces with a config.monitors assignment
            if toString ws == m.workspace then
              "${toString ws}, monitor:${m.name}, default:true, persistent:true"
            else
            # workspace 1 is persistent on the primary monitor
            if (ws == 1 || ws == "special") && m.primary == true then
              "${toString ws}, monitor:${m.name}, default:true, persistent:true"
            # FIXME(monitors): need logic to set primary as default monitor for workspaces that don't match above conditions but because we're limited to 'map' it seems to add more complexity than it's worth
            else
              ""
          ) config.monitors
        ) workspaceIDs
      );

      general = {
        layout = "dwindle";
        resize_on_border = true;
        gaps_in = 5;
        gaps_out = 10;
      };

      misc = {
        disable_splash_rendering = true;
        # force_default_wallpaper = 1;
        focus_on_activate = true;
      };

      input = {
        repeat_rate = 25;
        repeat_delay = 250;
        kb_layout = "us";
        follow_mouse = 1;
        touchpad = {
          natural_scroll = "yes";
          disable_while_typing = true;
          drag_lock = true;
        };
        sensitivity = 0;
        float_switch_override_focus = 2;
      };

      binds = {
        allow_workspace_cycles = true;
      };

      dwindle = {
        pseudotile = "yes";
        preserve_split = "yes";
        # no_gaps_when_only = "yes";
      };

      gestures = {
        workspace_swipe = true;
        workspace_swipe_use_r = true;
      };

      windowrule =
        let
          t = regex: "title:^(${regex})$";
          # f = regex: "float, title:^(${regex})$";
          f = regex: "float, ${t regex}";
        in
        [
          # (f "org.gnome.Calculator")
          # (f "org.gnome.Nautilus")
          # (f "org.gnome.Settings")
          # (f "org.gnome.design.Palette")
          (f "pavucontrol")
          (f "nm-connection-editor")
          # (f "blueberry.py")
          (f "Color Picker")
          # (f "xdg-desktop-portal")
          # (f "xdg-desktop-portal-gnome")
          # (f "transmission-gtk")
          # (f "com.github.Aylur.ags")
          (f "it.mijorus.smile")
          # (f "Picture-in-Picture")

          ''float, class:(org.gnome)(.*)''
          ''float, ${(t "Picture-in-Picture")}''
          ''pin, ${(t "Picture-in-Picture")}''
          ''size 640 360, ${(t "Picture-in-Picture")}''
          ''move 100%-w-20, ${(t "Picture-in-Picture")}''
          "workspace 4 silent, class:spotify"
          "workspace 4 silent, class:vesktop"
          "workspace 4 silent, class:Slack"

          "float, title:^(Open File)(.*)$"
          "float, title:^(Select a File)(.*)$"
          "float, title:^(Choose wallpaper)(.*)$"
          "float, title:^(Open Folder)(.*)$"
          "float, title:^(Save As)(.*)$"
          "float, title:^(Library)(.*)$"
          "float, title:^(Accounts)(.*)$"
        ];

      decoration = {
        rounding = 10;
        shadow = {
          enabled = true;
          range = 8;
          render_power = 2;
          color = "rgba(00000044)";
        };

        dim_inactive = false;

        blur = {
          enabled = true;
          size = 8;
          passes = 3;
          new_optimizations = "on";
          noise = 1.0e-2;
          contrast = 0.9;
          brightness = 0.8;
          popups = true;
        };
      };

      animations = {
        enabled = "yes";
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 5, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      plugin = {
        overview = {
          centerAligned = true;
          hideTopLayers = true;
          hideOverlayLayers = true;
          showNewWorkspace = true;
          exitOnClick = true;
          exitOnSwitch = true;
          drawActiveWorkspace = true;
          reverseSwipe = true;
        };
        hyprbars = {
          bar_color = "rgb(2a2a2a)";
          bar_height = 28;
          col_text = "rgba(ffffffdd)";
          bar_text_size = 11;
          bar_text_font = "FantasqueSansM Nerd Font";

          buttons = {
            button_size = 0;
            "col.maximize" = "rgba(ffffff11)";
            "col.close" = "rgba(ff111133)";
          };
        };
      };
    };
  };
}
