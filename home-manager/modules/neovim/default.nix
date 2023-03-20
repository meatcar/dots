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

    extraConfig = ''
      let g:parinfer_dylib_path = "${pkgs.parinfer-rust}/lib/libparinfer_rust.so"
      let g:sqlite_clib_path = "${pkgs.sqlite.out}/lib/libsqlite3.so"

      lua require('init')
    '';

    extraPackages = with pkgs; [
      luajitPackages.luarocks
      parinfer-rust

      # lsps
      rnix-lsp
      lua-language-server
      terraform-ls
      gopls
      ansible-language-server
      elixir_ls
      nodePackages.vscode-langservers-extracted # eslint
      nodePackages.typescript
      nodePackages.typescript-language-server
      nodePackages.bash-language-server
      nodePackages.dockerfile-language-server-nodejs
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
    vim-vint
    tree-sitter
    glow
    stylua
    cargo
  ];
}
