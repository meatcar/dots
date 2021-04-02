{ pkgs, config, ... }:
{
  programs.neovim = {
    enable = true;
    # from https://github.com/neovim/neovim/blob/master/contrib/flake.nix
    # TODO: move to flakes
    package = pkgs.neovim-unwrapped.overrideAttrs (oa: {
      pname = "neovim-nightly";
      version = "master";
      src = config.niv.neovim;
      buildInputs = oa.buildInputs ++ ([
        pkgs.tree-sitter
      ]);
      cmakeFlags = oa.cmakeFlags ++ [
        "-DUSE_BUNDLED=OFF"
      ];
    });
    withNodeJs = true;

    plugins = with pkgs; [ ];

    extraConfig = builtins.readFile ./init.vim;
  };

  xdg.configFile = {
    "nvim" = {
      recursive = true;
      source = ./nvim;
    };
  };

  home.packages = with pkgs; [ fortune shellcheck shfmt update-nix-fetchgit vim-vint ];
}
