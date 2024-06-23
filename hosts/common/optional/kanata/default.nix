{}: {
  services.kanata = {
    enable = true;
    keyboards = {
      devices = [ "/dev/input/by-path/platform-i8042-serio-0-event-kbd" ];
      "laptop".configFile = ./colmak.kbd;
    };
  };
}
