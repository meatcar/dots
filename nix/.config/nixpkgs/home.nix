{ config, pkgs, ... }:

{
  home.packages = builtins.attrValues {
    inherit (pkgs)
      curl htop mosh broot neomutt isync msmtp ripgrep jq rootlesskit docker
      docker-compose entr nox nixpkgs-fmt binutils gcc gnumake openssl pkgconfig
      ;
  };

  xdg.enable = true;
  home.sessionVariables.XDG_RUNTIME_DIR = "/run/user/$UID";
  fonts.fontconfig.enable = true;
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.man.enable = true;
  programs.bash.enable = true;
  programs.fzf.enable = true;

  imports = [
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
}
