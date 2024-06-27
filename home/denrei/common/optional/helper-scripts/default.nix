{
  pkgs,
  configVars,
  ...
}: let
  scripts = {
    # FIXME: I currently get the following warnings:
    # svn: warning: cannot set LC_CTYPE locale
    # svn: warning: environment variable LANG is en_US.UTF-8
    # svn: warning: please check that your locale name is correct
    copy-github-subfolder = pkgs.writeShellApplication {
      name = "copy-github-subfolder";
      runtimeInputs = with pkgs; [subversion];
      text = builtins.readFile ./copy-github-subfolder.sh;
    };
    linktree =
      pkgs.writeShellApplication
      {
        name = "linktree";
        runtimeInputs = with pkgs; [];
        text = builtins.readFile ./linktree.sh;
      };

    cows = pkgs.writeShellApplication {
      name = "moooo";
      runtimeInputs = with pkgs; [cowsay lolcat];

      text = ''
        cowsay "Mooooo" | lolcat

      '';
    };
    cdproject = pkgs.writeShellApplication {
      name = "cd-project";
      runtimeInputs = with pkgs; [fzf];

      text = ''
        if [[ $# -eq 1 ]]; then
        	selected=$1
        else
        	selected=$(find -L ~/codes -mindepth 1 -maxdepth 2 -type d | fzf) || return
        fi

        if [[ -z $selected ]]; then
        	exit 0
        fi

        selected_name=$(basename "$selected" | tr . _)

        GREEN='\033[0;32m'
        RED='\033[0;31m'
        BLUE='\033[0;34m'
        BOLD='\033[1m'
        NORMAL='\033[0m'

        if [[ "$(pwd)" == "$selected" ]]; then
        	echo " 📁 already in $selected_name"
        else
        	echo " 📁 going to $selected_name"
        	cd $selected
        fi
      '';
    };
    setenv = pkgs.writeShellApplication {
      name = "setenv";
      runtimeInputs = with pkgs; [python3];

      text = ''
        VENV_DIR="venv"

        if [[ ! -d "$VENV_DIR" ]]; then
        	echo "🐍 Creating virtual environment..."
        	python -m venv $VENV_DIR
        fi

        if [[ -z "$VIRTUAL_ENV" ]]; then
        	echo "🐍 Activating virtual environment..."
        	source $VENV_DIR/bin/activate
        else
        	echo "🐍 Virtual environment already active"
        fi
      '';
    };
  };
in {
  home.packages = builtins.attrValues {
    inherit
      (scripts)
      copy-github-subfolder
      linktree
      cows
      cdproject
      setenv
      ;
  };
}
