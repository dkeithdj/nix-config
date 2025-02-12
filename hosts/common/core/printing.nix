{ pkgs, ... }:
{
  services.avahi = {
    # nssmdns = true;
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
  services.printing = {
    listenAddresses = [ "*:631" ];
    allowFrom = [ "all" ];
    browsing = true;
    defaultShared = true;
    openFirewall = true;
    browsedConf = ''
      BrowseDNSSDSubTypes _cups,_print
      BrowseLocalProtocols all
      BrowseRemoteProtocols all
      CreateIPPPrinterQueues All

      BrowseProtocols all
    '';
    drivers = with pkgs; [
      gutenprint
      hplip
      brlaser
    ];
  };
}
