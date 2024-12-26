{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ../modules/nix-flakes.nix
    ../modules/cachix.nix
    ../modules/man
    ../modules/git
    ../modules/fish
    ../modules/ssh
    ../modules/direnv
    ../modules/lsd
    ../modules/tmux
    ../modules/neovim
    ../modules/weechat
    ../modules/leiningen
    ../modules/clojure
    ../modules/emacs
    ../modules/nnn
    ../modules/yazi
    ../modules/kakoune
    ../modules/helix
    ../modules/nix-index
    ../modules/starship
    ../modules/zellij
    ../modules/wakatime
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
    fx
    (lib.mkDefault (pkgs.writeShellScriptBin "get-theme-default" ''
      echo dark
    ''))
  ];

  xdg.enable = true;
  home.sessionVariables = {
    EDITOR = "nvim";
    NOTES_DIR = "~/Sync/notes";
    LESS = "-R --mouse";
  };
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.bash = {
    enable = true;
    enableCompletion = true;
    enableVteIntegration = true;
  };
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    enableVteIntegration = true;
    historySubstringSearch.enable = true;
  };
  programs.fzf.enable = true;
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
