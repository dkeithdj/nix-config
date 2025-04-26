# User config applicable only to darwin
{ config, pkgs, ... }:
{
  users.users.${config.hostSpec.username} = {
    home = "/Users/${config.hostSpec.username}";
  };

  users.users.root = {
    shell = pkgs.zsh;
  };
}
