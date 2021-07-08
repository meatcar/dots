{ pkgs, config, ... }:
let
  overlay = (import config.niv.neovim-nightly-overlay { }) pkgs;
in
{
  programs.neovim = {
    enable = true;
    # from https://github.com/neovim/neovim/blob/master/contrib/flake.nix
    # TODO: move to flakes
    package = overlay.neovim-nightly;
    withNodeJs = true;

    plugins = with pkgs; [ ];

    extraConfig = builtins.readFile ./init.vim;
  };

  xdg.configFile = {
    "nvim" = {
      recursive = true;
      source = ./nvim;
    };
    "luacheck/.luacheckrc".text = ''
      globals = {
          "vim",
      }
    '';
  };

  home.packages = with pkgs; [
    fortune
    shellcheck
    shfmt
    update-nix-fetchgit
    parinfer-rust
    vim-vint
    tree-sitter
    glow
    stylua
  ];
}
