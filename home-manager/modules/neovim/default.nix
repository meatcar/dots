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

    plugins = with pkgs.vimPlugins; [
      sqlite-lua
      # TODO: try again. for some reason the bash parser throws errors
      # nvim-treesitter.withAllGrammars
    ];

    extraPackages = with pkgs; [
      luajitPackages.luarocks
      parinfer-rust

      # lsps
      rnix-lsp
      nil
      lua-language-server
      terraform-ls
      gopls
      ansible-language-server
      elixir_ls
      nodePackages.vscode-langservers-extracted # css,eslint,html,json,markdown
      nodePackages.typescript
      nodePackages.typescript-language-server
      nodePackages.bash-language-server
      nodePackages.dockerfile-language-server-nodejs

      # formatters
      eslint_d
      nodePackages.prettier
      nodePackages.stylelint
      python3Packages.autopep8
      (pkgs.writeShellScriptBin "gofmt" ''
        ${pkgs.go}/bin/gofmt "$@"
      '')
    ];
  };

  xdg.configFile = {
    nvim.source = config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/git/hub/meatcar/dots/home-manager/modules/neovim/nvim";
    "luacheck/.luacheckrc".text = ''
      globals = {
          "vim",
      }
    '';
  };

  xdg.dataFile = {
    "nvim/lib/libparinfer_rust.so".source = "${pkgs.parinfer-rust}/lib/libparinfer_rust.so";
    "nvim/lib/libsqlite3.so".source = "${pkgs.sqlite.out}/lib/libsqlite3.so";
    # "nvim/lib/nvim-treesitter".source = "${pkgs.vimPlugins.nvim-treesitter.withAllGrammars}";
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
