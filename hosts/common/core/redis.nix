{pkgs, ...}: {
  services.redis.servers = {
    redis = {
      enable = true;
      package = pkgs.redis;
    };
  };
}
