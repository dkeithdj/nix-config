{pkgs, ...}: {
  services.cliphist = {
    enable = true;
    allowImages = true;
  };
}
