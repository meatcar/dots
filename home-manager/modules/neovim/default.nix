{ pkgs, config, ... }: {
  programs.neovim = {
    enable = true;
    package = pkgs.neovim-unwrapped;

    plugins = with pkgs; [ ];
  };

  xdg.configFile."nvim".source = ./nvim;
  # HACK: prevent HM from dropping its own Neovim config
  xdg.configFile."nvim/init.vim".target =
    "${config.xdg.dataHome}/home-manager/diverted/init.vim";

  home.packages = with pkgs; [ fortune shellcheck shfmt update-nix-fetchgit ];
}
