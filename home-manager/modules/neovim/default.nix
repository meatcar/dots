{
  pkgs,
  config,
  nixpkgs-unstable,
  ...
}:
{
  imports = [
    ../yazi
  ];

  programs.neovim = {
    enable = true;
    withNodeJs = true;
    # Keep legacy defaults (new defaults in stateVersion >= 26.05 are false)
    withRuby = true;
    withPython3 = true;
    # xdg.configFile."nvim" is an outOfStoreSymlink; pass generated plugin
    # init via --cmd instead of writing to ~/.config/nvim/init.lua
    sideloadInitLua = true;

    plugins = with pkgs.vimPlugins; [
      sqlite-lua
      # TODO: try again. for some reason the bash parser throws errors
      # nvim-treesitter.withAllGrammars
      (pkgs.callPackage (import ./darkman-nvim.nix) { })
    ];

    extraPackages = with pkgs; [
      luajitPackages.luarocks
      parinfer-rust
      fzf

      # for building plugins
      gnumake
      gcc

      # lsps
      nil
      statix
      lua-language-server
      terraform-ls
      gopls
      elixir-ls
      vscode-langservers-extracted # css,eslint,html,json,markdown
      typescript
      typescript-language-server
      bash-language-server
      dockerfile-language-server

      # formatters
      eslint_d
      python3Packages.autopep8
      (pkgs.writeShellScriptBin "gofmt" ''
        ${pkgs.go}/bin/gofmt "$@"
      '')
    ];
  };

  xdg.configFile = {
    nvim.source = config.lib.file.mkOutOfStoreSymlink "${config.me.PRJ_ROOT}/home-manager/modules/neovim/nvim";
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

  home.packages =
    with pkgs;
    [
      nixfmt
      fortune
      shellcheck
      shfmt
      update-nix-fetchgit
      vim-vint
      tree-sitter
      glow
      stylua
      cargo
    ]
    ++ [
      nixpkgs-unstable.oxfmt
    ];
}
