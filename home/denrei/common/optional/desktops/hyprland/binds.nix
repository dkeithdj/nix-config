{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
let

  grimblast = "${inputs.hyprland-contrib.packages.${pkgs.system}.grimblast}/bin/grimblast";
  notify-send = "${pkgs.libnotify}/bin/notify-send";
  brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
  playerctl = "${pkgs.playerctl}/bin/playerctl";
  pactl = "${pkgs.pulseaudio}/bin/pactl";

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
  wayland.windowManager.hyprland.settings = {

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
  };

}
