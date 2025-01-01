{
  pkgs,
  config,
  lib,
  configMk,
  inputs,
  ...
}:
let
  inherit (lib) mkIf types;
  inherit (configMk) mkOpt mkBoolOpt;
  cfg = config.apps.cli.nvim;
in
{
  options.apps.cli.nvim = with types; {
    enable = mkBoolOpt false "Enable neovim";
  };

  config = mkIf cfg.enable {
    xdg = {
      # configFile.nvim.source = ../nvim;
      # configFile.nvim.source = config.lib.file.mkOutOfStoreSymlink ../nvim;
      configFile.nvim.source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Projects/nix-config/modules/home/apps/cli/nvim";
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
        # cargo
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
        ruff-lsp
        black
        pyright
      ];
    };
  };
}
