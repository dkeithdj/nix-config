{
  pkgs,
  # lib,
  # config,
  ...
}:
let
  name = "Denrei Keith";
in
{
  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;
    userName = name;
    userEmail = "42316655+dkeithdj@users.noreply.github.com";
    aliases = { };
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = "true";
      color.ui = true;
      core.editor = "nvim";
      credential.helper = "store";
      github.user = name;
      push.autoSetupRemote = true;
    };
    # enable git Large File Storage: https://git-lfs.com/
    lfs.enable = true;
    ignores = [
      ".csvignore"
      # nix
      "*.drv"
      "result"
      # python
      "*.py?"
      "__pycache__/"
      ".venv/"
      # direnv
      ".direnv"
      "result"
    ];
  };
}
