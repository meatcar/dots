{ pkgs, config, ... }:
{
  programs.neovim = {
    enable = true;
    package = pkgs.neovim-nightly;
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
