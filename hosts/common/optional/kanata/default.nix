{
  pkgs,
  lib,
  ...
}: {
  environment.systemPackages = with pkgs; [kanata];

  services.kanata = {
    enable = lib.mkDefault true;
    keyboards = {
      canopus = {
        extraDefCfg = ''
          danger-enable-cmd yes
        '';
        devices = ["/dev/input/by-path/platform-i8042-serio-0-event-kbd"];
        configFile = ./colemak.kbd;
      };
      altair = {
        extraDefCfg = ''
          danger-enable-cmd yes
          process-unmapped-keys yes
        '';
        devices = ["/dev/input/by-path/pci-0000:02:00.0-usb-0:5:1.0-event-kbd"];
        configFile = ./homerowmods.kbd;
      };
    };

    services.udev.extraRules = ''
      KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"
    '';

    # qwerty.configuration = {
    #   services.kanata = {
    #     enable = false;
    #     keyboards = {
    #       laptop = {
    #         devices = [ "/dev/input/by-path/platform-i8042-serio-0-event-kbd" ];
    #         configFile = ./qwerty.kbd;
    #       };
    #     };
    #   };
    # };
  };
}
