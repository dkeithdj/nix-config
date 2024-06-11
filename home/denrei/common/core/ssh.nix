{ outputs, lib, ... }:
{
  programs.ssh = {
    enable = true;


    matchBlocks = {
      "git" = {
        host = "github.com";
        user = "git";
        forwardAgent = true;
        identitiesOnly = true;
        AddKeysToAgent = "yes";
        identityFile = [
          "~/.ssh/id_ed25519_github"
        ];
      };
    };
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
