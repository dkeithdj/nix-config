{
  inputs,
  config,
  lib,
  configVars,
  ...
}: {
  nix = {
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: {flake = value;}) inputs;

    # This will add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;
    settings = {
      # See https://jackson.dev/post/nix-reasonable-defaults/
      connect-timeout = 5;
      log-lines = 25;
      min-free = 128000000; # 128MB
      max-free = 1000000000; # 1GB
      trusted-users = ["root" configVars.username];
      # trusted-public-keys = ["devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="];
      # substituters = ["https://devenv.cachix.org"];

      # Deduplicate and optimize nix store
      auto-optimise-store = true;

      experimental-features = ["nix-command" "flakes"];
      warn-dirty = false;
    };

    # Garbage Collection
    # gc = {
    #   automatic = true;
    #   options = "--delete-older-than 10d";
    # };
  };
}
