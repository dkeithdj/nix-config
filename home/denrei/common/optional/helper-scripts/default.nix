{
  pkgs,
  ...
}:
let
  scripts = {
    # FIXME: I currently get the following warnings:
    # svn: warning: cannot set LC_CTYPE locale
    # svn: warning: environment variable LANG is en_US.UTF-8
    # svn: warning: please check that your locale name is correct
    copy-github-subfolder = pkgs.writeShellApplication {
      name = "copy-github-subfolder";
      runtimeInputs = with pkgs; [ subversion ];
      text = builtins.readFile ./copy-github-subfolder.sh;
    };
    linktree = pkgs.writeShellApplication {
      name = "linktree";
      runtimeInputs = with pkgs; [ ];
      text = builtins.readFile ./linktree.sh;
    };

    cows = pkgs.writeShellApplication {
      name = "moooo";
      runtimeInputs = with pkgs; [
        cowsay
        lolcat
      ];

      text = ''
        cowsay "Mooooo" | lolcat

      '';
    };
    # cdproject = pkgs.writeShellApplication {
    #   name = "cd-project";
    #   runtimeInputs = with pkgs; [fzf];
    #   text = builtins.readFile ./cd-project.sh;
    # };
    # setenv = pkgs.writeShellApplication {
    #   name = "setenv";
    #   runtimeInputs = with pkgs; [python3];
    #   text = builtins.readFile ./setenv.sh;
    # };
  };
in
{
  home.packages = builtins.attrValues {
    inherit (scripts)
      copy-github-subfolder
      linktree
      cows
      # cdproject

      # setenv

      ;
  };
}
