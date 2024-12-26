{
  options,
  config,
  pkgs,
  lib,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.user;
in {
  options.user = with types; {
    name = mkOpt str "denrei" "The name to use for the user account.";
    initialPassword =
      mkOpt str "password"
      "The initial password to use when the user is first created.";
    icon =
      mkOpt (nullOr package) defaultIcon
      "The profile picture to use for the user.";
    extraGroups = mkOpt (listOf str) [] "Groups for the user to be assigned.";
    extraOptions =
      mkOpt attrs {}
      "Extra options passed to <option>users.users.<name></option>.";
  };

  config = {
    environment.systemPackages = with pkgs; [
      propagatedIcon
    ];

    environment.sessionVariables.FLAKE = "/home/iogamaster/.dotfiles";

    home = {
      file = {
        "Documents/.keep".text = "";
        "Downloads/.keep".text = "";
        "Music/.keep".text = "";
        "Pictures/.keep".text = "";
        "dev/.keep".text = "";
        ".face".source = cfg.icon;
        "Pictures/${
          cfg.icon.fileName or (builtins.baseNameOf cfg.icon)
        }".source =
          cfg.icon;
      };
    };

    users.users.${cfg.name} =
      {
        isNormalUser = true;
        inherit (cfg) name initialPassword;
        home = "/home/${cfg.name}";
        group = "users";

        extraGroups =
          ["wheel" "audio" "sound" "video" "networkmanager" "input" "tty" "docker"]
          ++ cfg.extraGroups;
      }
      // cfg.extraOptions;
  };
}
