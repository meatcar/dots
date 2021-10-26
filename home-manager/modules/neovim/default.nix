{ pkgs, config, ... }:
{
  imports = [
    ../nnn
  ];

  programs.neovim = {
    enable = true;
    package = pkgs.neovim-nightly.override {
      lua = pkgs.luajit;
    };
    withNodeJs = true;

    plugins = with pkgs.vimPlugins; [ sqlite-lua ];

    extraConfig = builtins.readFile ./init.vim;
    extraPackages = [
      pkgs.luajitPackages.luarocks
    ];
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
