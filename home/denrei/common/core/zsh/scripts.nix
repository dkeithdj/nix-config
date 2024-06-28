{pkgs, ...}: let
  GREEN = "'\033[0;32m'";
  BLUE = "'\033[0;34m'";
  BOLD = "'\033[1m'";
  NORMAL = "'\033[0m'";
  cd-project = pkgs.writeShellApplication {
    name = "cd-project";

    runtimeInputs = with pkgs; [fzf];

    text = ''
      if [[ $# -eq 1 ]]; then
      	selected=$1
      else
      	selected=$(find -L ~/Projects -mindepth 1 -maxdepth 2 -type d | fzf) || return
      fi

      if [[ -z $selected ]]; then
      	exit 0
      fi

      selected_name=$(basename "$selected" | tr . _)


      if [[ "$(pwd)" == "$selected" ]]; then
      	echo " 📁 ${BLUE}already in${NORMAL} ${BOLD}$selected_name"
      else
      	echo " 📁 ${GREEN}going to${NORMAL} ${BOLD}$selected_name"
      	cd "$selected"
      fi
    '';
  };
in {
  cd-project = cd-project;
}
