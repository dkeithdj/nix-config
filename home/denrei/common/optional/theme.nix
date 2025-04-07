{
  pkgs,
  config,
  ...
}:
let
  theme = {
    name = "adw-gtk3-dark";
    package = pkgs.adw-gtk3;
  };
  cursorTheme = {
    name = "Qogir";
    size = 24;
    package = pkgs.qogir-icon-theme;
  };
  iconTheme = {
    name = "MoreWaita";
    package = pkgs.morewaita-icon-theme;
  };
in
{
  home = {
    packages =
      with pkgs;
      [
        cantarell-fonts
        font-awesome
        theme.package
        cursorTheme.package
        iconTheme.package
        adwaita-icon-theme
        papirus-icon-theme
      ]
      ++ (with pkgs.nerd-fonts; [
        ubuntu
        ubuntu-mono
        caskaydia-cove
        fantasque-sans-mono
        fira-code
        mononoki
      ]);
    sessionVariables = {
      XCURSOR_THEME = cursorTheme.name;
      XCURSOR_SIZE = "${toString cursorTheme.size}";
    };
    pointerCursor = cursorTheme // {
      gtk.enable = true;
    };
    file = {
      ".config/gtk-4.0/gtk.css".text = ''
        window.messagedialog .response-area > button,
        window.dialog.message .dialog-action-area > button,
        .background.csd{
          border-radius: 0;
        }
      '';
    };
  };

  fonts.fontconfig.enable = true;

  gtk = {
    inherit cursorTheme iconTheme;
    theme.name = theme.name;
    enable = true;
    gtk3.extraCss = ''
      headerbar, .titlebar,
      .csd:not(.popup):not(tooltip):not(messagedialog) decoration{
        border-radius: 0;
      }
    '';
  };

  qt = {
    enable = true;
    platformTheme.name = "kde";
  };

  home.file.".local/share/flatpak/overrides/global".text =
    let
      dirs = [
        "/nix/store:ro"
        "xdg-config/gtk-3.0:ro"
        "xdg-config/gtk-4.0:ro"
        "${config.xdg.dataHome}/icons:ro"
      ];
    in
    ''
      [Context]
      filesystems=${builtins.concatStringsSep ";" dirs}
    '';
}
