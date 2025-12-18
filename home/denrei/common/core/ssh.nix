{
  ...
}:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    matchBlocks = {
      "git" = {
        host = "github.com";
        user = "git";
        forwardAgent = true;
        identitiesOnly = true;
        identityFile = [
          "~/.ssh/id_ed25519_github"
        ];
        serverAliveCountMax = 3;
        serverAliveInterval = 5; # 3 * 5s
        addKeysToAgent = "yes";
      };
      "work-meterz" = {
        host = "github-meterz";
        hostname = "github.com";
        user = "git";
        forwardAgent = true;
        identitiesOnly = true;
        identityFile = [
          "~/.ssh/id_work_meterz"
        ];
        serverAliveCountMax = 3;
        serverAliveInterval = 5; # 3 * 5s
        addKeysToAgent = "yes";
      };
    };

    # Avoids infinite hang if control socket connection interrupted. ex: vpn goes down/up
    # serverAliveCountMax = 3;
    # serverAliveInterval = 5; # 3 * 5s
    # FIXME: This should probably be for git systems only?
    #controlMaster = "auto";
    #controlPath = "~/.ssh/sockets/S.%r@%h:%p";
    #controlPersist = "60m";

    #extraConfig = ''
    #Include config.d/*
    #'';
  };
  #  home.file.".ssh/sockets/.keep".text = "# Managed by Home Manager";
}
