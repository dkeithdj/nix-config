{
  inputs,
  lib,
  config,
  ...
}:
{
  imports = lib.flatten [
    inputs.nix-homebrew.darwinModules.nix-homebrew
    {
      nix-homebrew = {
        enable = true;
        user = config.hostSpec.username;
        taps = {
          "homebrew/homebrew-core" = inputs.homebrew-core;
          "homebrew/homebrew-cask" = inputs.homebrew-cask;
          "nikitabobko/homebrew-tap" = inputs.aerospace;
          "FelixKratz/homebrew-formulae" = inputs.jankyborders;
          "MediosZ/homebrew-tap" = inputs.aerospace-swipe;
        };

        enableRosetta = true;
        mutableTaps = false;
      };
    }

    (map lib.custom.relativeToRoot [
      "hosts/common/optional/homebrew"
    ])

  ];

  security.sudo.extraConfig = ''
    Defaults lecture = never # rollback results in sudo lectures after each reboot, it's somewhat useless anyway
    Defaults pwfeedback # password input feedback - makes typed password visible as asterisks
    Defaults timestamp_timeout=120 # only ask for password every 2h
    # Keep SSH_AUTH_SOCK so that pam_ssh_agent_auth.so can do its magic.
    Defaults env_keep+=SSH_AUTH_SOCK
  '';
}
