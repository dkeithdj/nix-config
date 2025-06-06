{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  xdg = {
    # configFile.nvim.source = ../nvim;
    # configFile.nvim.source = config.lib.file.mkOutOfStoreSymlink ../nvim;
    configFile.nvim.source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Projects/nix-config/home/${config.hostSpec.username}/common/core/nvim";
    desktopEntries."nvim" = lib.mkIf pkgs.stdenv.isLinux {
      name = "NeoVim";
      comment = "Edit text files";
      exec = "wezterm -e ${pkgs.neovim}/bin/nvim %F";
      icon = "nvim";
      categories = [ "TerminalEmulator" ];
      terminal = false;
      mimeType = [ "text/plain" ];
    };
  };
  programs.neovim = {
    enable = true;
    package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;
    viAlias = true;
    vimAlias = true;

    withRuby = true;
    withNodeJs = true;
    withPython3 = true;

    extraPackages = with pkgs; [
      git
      gcc
      gnumake
      unzip
      wget
      curl
      tree-sitter
      ripgrep
      fd
      fzf
      cargo
      go
      python3
      nodejs

      prettierd
      # marksman
      nil
      lua-language-server
      luarocks
      lua
      stylua
      alejandra
      nodePackages.eslint
      eslint_d
      nodePackages.prettier
      ruff
      black
      pyright
    ];
  };
}
