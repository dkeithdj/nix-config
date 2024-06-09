{ pkgs, lib, config, ... }:
{
  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;
    userName = "Denrei Keith";
    userEmail = "42316655+dkeithdj@users.noreply.github.com";
    aliases = { };
    extraConfig = {
      init.defaultBranch = "main";
    };
    # enable git Large File Storage: https://git-lfs.com/
    lfs.enable = true;
    ignores = [ ".direnv" "result" ];
  };
}
