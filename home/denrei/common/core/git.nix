{
  pkgs,
  lib,
  config,
  ...
}:
let
  name = "Denrei Keith";
  sshFolder = "${config.home.homeDirectory}/.ssh";
  userEmail = "42316655+dkeithdj@users.noreply.github.com";
  publicKey = "${sshFolder}/id_deneb.pub";
in
{
  home.file.".ssh/allowed_signers".text = ''
    ${userEmail} ${lib.fileContents (lib.custom.relativeToRoot "hosts/common/users/primary/keys/id_deneb.pub")}
  '';
  home.file.".ssh/id_deneb.pub".text = ''
    ${lib.fileContents (lib.custom.relativeToRoot "hosts/common/users/primary/keys/id_deneb.pub")}
  ''; # this only does one pubkey
  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;
    userName = name;
    userEmail = userEmail;
    aliases = { };
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = "true";
      color.ui = true;
      core.editor = "nvim";
      credential.helper = "store";
      github.user = name;
      push.autoSetupRemote = true;

      commit.gpgSign = true;
      gpg.format = "ssh";
      gpg.ssh.allowedSignersFile = "${sshFolder}/allowed_signers";
      user.signingkey = publicKey;
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
      ".DS_Store"
    ];
  };
}
