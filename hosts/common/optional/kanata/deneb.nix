{
  pkgs,
  ...
}:
{
  # environment.systemPackages = with pkgs; [ kanata ];

  launchd.daemons = {
    karabiner-vhiddaemon = {
      serviceConfig = {
        ProgramArguments = [
          "/Library/Application Support/org.pqrs/Karabiner-DriverKit-VirtualHIDDevice/Applications/Karabiner-VirtualHIDDevice-Daemon.app/Contents/MacOS/Karabiner-VirtualHIDDevice-Daemon"
        ];
        KeepAlive = true;
        RunAtLoad = true;
      };
    };
    karabiner-vhidmanager = {
      serviceConfig = {
        ProgramArguments = [
          "/Applications/.Karabiner-VirtualHIDDevice-Manager.app/Contents/MacOS/Karabiner-VirtualHIDDevice-Manager"
          "activate"
        ];
        RunAtLoad = true;
      };
    };
    kanata = {
      serviceConfig = {
        ProgramArguments = [
          "/opt/homebrew/bin/kanata"
          "-c"
          "/Users/denrei/Projects/nix-config/hosts/common/optional/kanata/graphite_mac.kbd"
          "--port"
          "10000"
          "--debug"
        ];
        KeepAlive = true;
        RunAtLoad = true;
        StandardErrorPath = "/var/log/kanata.err.log";
        StandardOutPath = "/var/log/kanata.out.log";
      };
    };
  };
}
