{ config, pkgs, lib, ... }:

{
  imports = [
    ./system.nix
    ./modules/man
    ./modules/git
    ./modules/fish
    ./modules/zsh
    ./modules/ssh
    ./modules/tmux
    ./modules/neovim
    ./modules/kakoune
    ./modules/weechat
    ./modules/leiningen
  ];

  home.packages = builtins.attrValues {
    inherit (pkgs)
      curl htop mosh broot neomutt isync msmtp ripgrep jq rootlesskit docker
      docker-compose entr nox nixpkgs-fmt binutils gcc gnumake openssl
      pkgconfig imgcat
      ;
  };

  xdg.enable = true;
  home.sessionVariables = lib.mkDefault {
    XDG_RUNTIME_DIR = "/run/user/$UID";
    EDITOR = "nvim";
  };
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.bash.enable = true;
  programs.fzf.enable = true;
}
