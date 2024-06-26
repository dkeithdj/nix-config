{pkgs, ...}: {
  programs.gh = {
    enable = true;
    extensions = with pkgs; [gh-markdown-preview];
    settings = {
      git_protocol = "http";
      prompt = "enabled";
    };
  };
  programs.gh-dash = {
    enable = true;
  };
}
