{ config, pkgs, lib, ... }:

{
  imports = [
    ../modules/niv.nix
    ./system.nix
    ./modules/man
    ./modules/git
    ./modules/fish
    ./modules/ssh
    ./modules/tmux
    ./modules/neovim
    ./modules/weechat
    ./modules/leiningen
  ];

  options =
    let
      inherit (lib) mkOption types;
      theme = {
        alacritty = mkOption {
          description = "Alacritty theme YAML";
          type = types.path;
        };
      };
    in
      {
        themes = {
          light = theme;
          dark = theme;
        };
      };

  config = rec {
    home.stateVersion = "19.09";
    home.packages = builtins.attrValues {
      inherit (pkgs)
        curl htop mosh neomutt isync msmtp ripgrep jq rootlesskit docker
        docker-compose entr nox nixpkgs-fmt binutils gcc gnumake openssl
        pkgconfig imgcat direnv
        ;
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

    themes =
      let
        base16 = config.niv.base16-alacritty;
      in
        {
          light.alacritty =
            "${base16}/colors/base16-summerfruit-light-256.yml";
          dark.alacritty =
            "${base16}/colors/base16-summerfruit-dark-256.yml";
        };
  };
}