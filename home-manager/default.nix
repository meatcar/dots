{ config, pkgs, lib, ... }:

{
  imports = [
    ../modules/niv.nix
    ./system.nix
    ./modules/man
    ./modules/git
    ./modules/fish
    ./modules/ssh
    ./modules/direnv
    ./modules/tmux
    ./modules/neovim
    ./modules/weechat
    ./modules/leiningen
    ./modules/clojure
    ./modules/emacs
    ./modules/nnn
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
      theme = theme;
    };

  config = rec {
    home.stateVersion = "19.09";
    home.packages = builtins.attrValues {
      inherit (pkgs)
        curl htop mosh eternal-terminal neomutt isync msmtp ripgrep jq
        docker docker-compose entr nox nixpkgs-fmt nixfmt binutils
        gcc gnumake openssl pkgconfig imgcat hydra-check;
    };

    xdg.enable = true;
    home.sessionVariables = {
      EDITOR = "nvim";
      NOTES_DIR = "~/Sync/notes";
    };
    nixpkgs.config = import ./config.nix;
    xdg.configFile."nixpkgs/config.nix".text =
      let
        seqToString = lib.generators.toPretty { };
        nixpkgsConfig = lib.filterAttrs (n: v: n != "packageOverrides") config.nixpkgs.config;
      in
      seqToString nixpkgsConfig;
    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;
    programs.bash.enable = true;
    programs.fzf.enable = true;
    programs.lsd.enable = true;
    programs.lsd.enableAliases = true;

    theme = config.themes.dark;
    themes =
      let
        theme = config.niv.alacritty-theme;
      in
      {
        light.alacritty = "${theme}/themes/pencil_light.yaml";
        dark.alacritty = "${theme}/themes/hyper.yaml";
      };
  };
}
