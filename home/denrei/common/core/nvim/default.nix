{ config
, lib
, pkgs
, inputs
, configVars
, ...
}: {
  xdg = {
    # configFile.nvim.source = ../nvim;
    # configFile.nvim.source = config.lib.file.mkOutOfStoreSymlink ../nvim;
    configFile.nvim.source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Projects/nix-config/home/${configVars.username}/common/core/nvim";
    desktopEntries."nvim" = lib.mkIf pkgs.stdenv.isLinux {
      name = "NeoVim";
      comment = "Edit text files";
      icon = "nvim";
      exec = "kitty -e ${pkgs.neovim}/bin/nvim %F";
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

      nil
      lua-language-server
      stylua
      alejandra
      nodePackages.eslint
      nodePackages.prettier
    ];
  };
}
