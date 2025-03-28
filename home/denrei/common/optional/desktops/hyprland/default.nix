{
  inputs,
  pkgs,
  ...
}:
let
  # hyprland = inputs.hyprland.packages.${pkgs.system}.hyprland;
  # plugins = inputs.hyprland-plugins.packages.${pkgs.system};

  yt = pkgs.writeShellScript "yt" ''
    notify-send "Opening video" "$(wl-paste)"
    mpv "$(wl-paste)"
  '';

  grimblast = "${inputs.hyprland-contrib.packages.${pkgs.system}.grimblast}/bin/grimblast";
  playerctl = "${pkgs.playerctl}/bin/playerctl";
  brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
  pactl = "${pkgs.pulseaudio}/bin/pactl";
  notify-send = "${pkgs.libnotify}/bin/notify-send";

  snapshot = pkgs.writeShellScriptBin "snapshot" ''
    outputDir="$HOME/Pictures/Screenshots/"
    outputFile="snapshot_$(date +%Y-%m-%d_%H-%M-%S).png"
    outputPath="$outputDir/$outputFile"
    mkdir -p "$outputDir"

    mode=''${1:-area}

    case "$mode" in
    active)
        command="${grimblast} copysave active $outputPath"
        ;;
    output)
        command="${grimblast} copysave output $outputPath"
        ;;
    area)
        command="${grimblast} copysave area $outputPath"
        ;;
    *)
        echo "Invalid option: $mode"
        echo "Usage: $0 {active|output|area}"
        exit 1
        ;;
    esac


    if eval "$command"; then
        recentFile=$(find "$outputDir" -name 'snapshot_*.png' -printf '%T+ %p\n' | sort -r | head -n 1 | cut -d' ' -f2-)
        ${notify-send} "Grimblast" "Your snapshot has been saved." \
            -i video-x-generic \
            -a "Grimblast" \
            -t 7000 \
            -u normal \
            --action="scriptAction:-xdg-open $outputDir=Directory" \
            --action="scriptAction:-xdg-open $recentFile=View"
    fi
  '';
in
{
  xdg.desktopEntries."org.gnome.Settings" = {
    name = "Settings";
    comment = "Gnome Control Center";
    icon = "org.gnome.Settings";
    exec = "env XDG_CURRENT_DESKTOP=gnome ${pkgs.gnome-control-center}/bin/gnome-control-center";
    categories = [ "X-Preferences" ];
    terminal = false;
  };

  home.packages = [
    inputs.hyprland-contrib.packages.${pkgs.system}.grimblast # or any other package
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;
    # systemd.enable = true;
    xwayland.enable = true;
    plugins = [
      inputs.hyprland-hyprspace.packages.${pkgs.system}.default
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

      monitor = [
        # "eDP-1, 1920x1080, 0x0, 1"
        # "HDMI-A-1, 2560x1440, 1920x0, 1"
        "DP-2, 2560x1440@75.00Hz, 0x0, 1"
      ];

      general = {
        layout = "dwindle";
        resize_on_border = true;
        gaps_in = 5;
        gaps_out = 10;
      };

      misc = {
        disable_splash_rendering = true;
        force_default_wallpaper = 1;
        focus_on_activate = true;
      };

      input = {
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
          f = regex: "float, ^(${regex})$";
        in
        [
          (f "org.gnome.Calculator")
          (f "org.gnome.Nautilus")
          (f "pavucontrol")
          (f "nm-connection-editor")
          (f "blueberry.py")
          (f "org.gnome.Settings")
          (f "org.gnome.design.Palette")
          (f "Color Picker")
          (f "xdg-desktop-portal")
          (f "xdg-desktop-portal-gnome")
          # (f "transmission-gtk")
          # (f "com.github.Aylur.ags")
          (f "it.mijorus.smile")
          (f "Picture-in-Picture")
        ];

      windowrulev2 =
        let
          t = regex: "title:^(${regex})$";
        in
        [
          ''float, ${(t "Picture-in-Picture")}''
          ''pin, ${(t "Picture-in-Picture")}''
          ''size 640 360, ${(t "Picture-in-Picture")}''
          ''move 100%-w-20, ${(t "Picture-in-Picture")}''
          "workspace 4, class:spotify"
          "workspace 4, class:vesktop"
        ];

      bind =
        let
          binding =
            mod: cmd: key: arg:
            "${mod}, ${key}, ${cmd}, ${arg}";
          mvfocus = binding "SUPER" "movefocus";
          ws = binding "SUPER" "workspace";
          resizeactive = binding "SUPER CTRL" "resizeactive";
          mvactive = binding "SUPER ALT" "moveactive";
          mvtows = binding "SUPER SHIFT" "movetoworkspace";
          mvtowssilent = binding "SUPER SHIFT CTRL" "movetoworkspacesilent";
          e = "exec, ags -b hypr";
          # e = "exec, hyprpanel";
          arr = [
            1
            2
            3
            4
            5
            6
            7
          ];
        in
        [
          "SUPER CTRL SHIFT, R,  ${e} quit; ags -b hypr"
          # "SUPER CTRL SHIFT, R,  ${e} q; hyprpanel"
          "SUPER, R,       exec, rofi -show drun"
          "SUPER, Tab,     ${e} -t overview"
          "SUPER,BACKSPACE,${e} t powermenu"
          # ",XF86PowerOff,  ${e} -r 'powermenu.shutdown()'"
          # "SUPER, bracketleft,  ${e} -r 'recorder.start()'"
          # "SUPER, bracketright, ${e} -r 'recorder.stop()'"
          ",Print,         exec, ${snapshot}/bin/snapshot"
          # "SHIFT,Print,    ${e} -r 'recorder.screenshot(true)'"
          # "SUPER, V,    ${e} -r 'launcher.open(\":ch \")'"
          "SUPER, V, exec, rofi -modi clipboard:${pkgs.cliphist}/bin/cliphist-rofi-img -show clipboard -show-icons"
          "SUPER, C, exec, rofi -show calc"
          # "SUPER, period,    ${e} -r 'launcher.open(\":em \")'"
          # "SUPER, period,    exec, smile"
          "SUPER, period,    exec, rofi -show emoji"
          "SUPER, Return, exec, wezterm -e"
          "SUPER, W, exec, zen"
          "SUPER, T, exec, wezterm"
          "SUPER, X, exec, zed"
          "SUPER, D, exec, vesktop"
          "SUPER, M, exec, spotify"
          "SUPER, E, exec, nautilus"
          "SUPER, I, exec, gtk-launch org.gnome.Settings"

          # youtube
          ", XF86Launch1,  exec, ${yt}"

          "ALT, Tab, focuscurrentorlast"
          "CTRL ALT, Delete, exit"
          "ALT, Q, killactive"
          "SUPER, F, togglefloating"
          "SUPER, G, fullscreen"
          "SUPER, Z, fullscreen, 1"
          "SUPER, P, togglesplit"

          (mvfocus "k" "u")
          (mvfocus "j" "d")
          (mvfocus "l" "r")
          (mvfocus "h" "l")
          (ws "left" "e-1")
          (ws "right" "e+1")
          (mvtows "left" "e-1")
          (mvtows "right" "e+1")
          (resizeactive "k" "0 -20")
          (resizeactive "j" "0 20")
          (resizeactive "l" "20 0")
          (resizeactive "h" "-20 0")
          (mvactive "k" "0 -20")
          (mvactive "j" "0 20")
          (mvactive "l" "20 0")
          (mvactive "h" "-20 0")
        ]
        ++ (map (i: ws (toString i) (toString i)) arr)
        ++ (map (i: mvtows (toString i) (toString i)) arr)
        ++ (map (i: mvtowssilent (toString i) (toString i)) arr);

      bindle = [
        ",XF86MonBrightnessUp,   exec, ${brightnessctl} set +5%"
        ",XF86MonBrightnessDown, exec, ${brightnessctl} set  5%-"
        ",XF86KbdBrightnessUp,   exec, ${brightnessctl} -d asus::kbd_backlight set +1"
        ",XF86KbdBrightnessDown, exec, ${brightnessctl} -d asus::kbd_backlight set  1-"
        ",XF86AudioRaiseVolume,  exec, ${pactl} set-sink-volume @DEFAULT_SINK@ +5%"
        ",XF86AudioLowerVolume,  exec, ${pactl} set-sink-volume @DEFAULT_SINK@ -5%"
      ];

      bindl = [
        ",XF86AudioPlay,    exec, ${playerctl} play-pause"
        ",XF86AudioStop,    exec, ${playerctl} stop"
        ",XF86AudioPause,   exec, ${playerctl} pause"
        ",XF86AudioMute,    exec, ${playerctl} toggle-mute"
        ",XF86AudioPrev,    exec, ${playerctl} previous"
        ",XF86AudioNext,    exec, ${playerctl} next"
        ",XF86AudioMicMute, exec, ${pactl} set-source-mute @DEFAULT_SOURCE@ toggle"
      ];

      bindm = [
        "SUPER, mouse:273, resizewindow"
        "SUPER, mouse:272, movewindow"
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
