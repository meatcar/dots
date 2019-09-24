{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    package = pkgs.neovim-unwrapped;

    plugins = with pkgs; [];
  };

  xdg.configFile."nvim".source = ./nvim;

  home.packages = with pkgs; [];
}
