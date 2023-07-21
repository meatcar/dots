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
    ../modules/starship
  ];

  home.packages = with pkgs; [
    curl
    htop
    mosh
    eternal-terminal
    neomutt
    isync
    msmtp
    ripgrep
    jq
    docker
    docker-compose
    lazydocker
    entr
    nox
    nixpkgs-fmt
    statix
    binutils
    gcc
    gnumake
    openssl
    pkg-config
    imgcat
    hydra-check
    nvd
    fd
    (pkgs.writeShellScriptBin "get-theme" ''
      THEME_FILE=/mnt/c/Users/meatcar/.config/theme
      if [ -f "$THEME_FILE" ]; then
        cat "$THEME_FILE"
      else
        echo "dark"
      fi
    '')
  ];

  xdg.enable = true;
  home.sessionVariables = {
    EDITOR = "nvim";
    NOTES_DIR = "~/Sync/notes";
    # color man
    MANPAGER = "less";
    LESS = "-R --mouse";
    LESS_TERMCAP_mb = "$(tput bold; tput setaf 2)";
    LESS_TERMCAP_md = "$(tput bold; tput setaf 6)";
    LESS_TERMCAP_me = "$(tput sgr0)";
    LESS_TERMCAP_so = "$(tput bold)";
    LESS_TERMCAP_se = "$(tput rmso; tput sgr0)";
    LESS_TERMCAP_us = "$(tput bold; tput setaf 4)";
    LESS_TERMCAP_ue = "$(tput sgr0)";
    LESS_TERMCAP_mr = "$(tput rev)";
    LESS_TERMCAP_mh = "$(tput dim)";
    LESS_TERMCAP_ZN = "$(tput ssubm)";
    LESS_TERMCAP_ZV = "$(tput rsubm)";
    LESS_TERMCAP_ZO = "$(tput ssupm)";
    LESS_TERMCAP_ZW = "$(tput rsupm)";

  };
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.bash.enable = true;
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
    enableVteIntegration = true;
    historySubstringSearch.enable = true;
  };
  programs.fzf.enable = true;
  programs.lsd.enable = true;
  programs.lsd.enableAliases = true;
  programs.dircolors.enable = true;
  programs.zoxide.enable = true;
  programs.bat = {
    enable = true;
    config.theme = "ansi";
    extraPackages = with pkgs.bat-extras; [
      batdiff
      batman
      batgrep
      batwatch
    ];
  };
  programs.less = {
    enable = true;
  };
}
