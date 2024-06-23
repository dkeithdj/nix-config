{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    kanata
  ];

  services.kanata = {
    enable = true;
    keyboards = {
      laptop = {
      devices = [ "/dev/input/by-path/platform-i8042-serio-0-event-kbd" ];
      configFile = ./colemak.kbd;
        };
    };
  };
}
