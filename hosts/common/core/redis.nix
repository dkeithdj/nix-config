{pkgs, ...}: {
  services.redis = {
    package = pkgs.redis;
    servers = {
      "redis" = {
        enable = true;
      };
    };
  };
}
