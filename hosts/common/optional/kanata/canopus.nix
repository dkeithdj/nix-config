{
  pkgs,
  lib,
  ...
}:
{
  environment.systemPackages = with pkgs; [ kanata ];

  services.kanata = {
    enable = lib.mkDefault true;
    keyboards = {
      canopus = {
        extraDefCfg = ''
          danger-enable-cmd yes
        '';
        devices = [ "/dev/input/by-path/platform-i8042-serio-0-event-kbd" ];
        configFile = ./colemak.kbd;
      };
    };
  };

  services.udev.extraRules = ''
    KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"
  '';
}
