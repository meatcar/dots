{ config, lib, pkgs, ... }:
{
  imports = [
    ../modules/base.nix
    ../modules/nix-flakes.nix
    ../modules/cachix.nix
    ../modules/man
    ../modules/git
    ../modules/fish
    ../modules/ssh
    ../modules/direnv
    ../modules/tmux
    ../modules/neovim
    ../modules/weechat
    ../modules/leiningen
    ../modules/clojure
    ../modules/emacs
    ../modules/nnn
    ../modules/kakoune
  ];
}
