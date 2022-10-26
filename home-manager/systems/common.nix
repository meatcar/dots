{ config, lib, pkgs, ... }:
{
  imports = [
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
    ../modules/helix
    ../modules/nix-index
  ];

  home.packages = builtins.attrValues {
    inherit (pkgs)
      curl htop mosh eternal-terminal neomutt isync msmtp ripgrep jq
      docker docker-compose entr nox nixpkgs-fmt statix binutils
      gcc gnumake openssl pkg-config imgcat hydra-check nvd;
  };

  xdg.enable = true;
  home.sessionVariables = {
    EDITOR = "nvim";
    NOTES_DIR = "~/Sync/notes";
  };
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.bash.enable = true;
  programs.fzf.enable = true;
  programs.lsd.enable = true;
  programs.lsd.enableAliases = true;
  programs.dircolors.enable = true;
}
