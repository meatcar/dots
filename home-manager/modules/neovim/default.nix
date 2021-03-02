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

    plugins = with pkgs; [ ];
  };

  xdg.configFile."nvim".source = ./nvim;
  # HACK: prevent HM from dropping its own Neovim config
  xdg.configFile."nvim/init.vim".target =
    "${config.xdg.dataHome}/home-manager/diverted/init.vim";

  home.packages = with pkgs; [ fortune shellcheck shfmt update-nix-fetchgit ];
}
