{ pkgs, lib, ... }:
{
  environment.systemPackages = with pkgs; [ kanata ];

  systemd.services.kanafa.wantedBy = lib.mkForce [ ];
  services.kanata = {
    enable = lib.mkDefault true;
    keyboards = {
      laptop = {
        devices = [ "/dev/input/by-path/platform-i8042-serio-0-event-kbd" ];
        configFile = ./colemak.kbd;
      };
    };

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
