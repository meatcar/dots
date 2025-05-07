{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ../modules/nix.nix
    ../modules/nix-your-shell
    ../modules/man
    ../modules/git
    ../modules/fish
    ../modules/starship
    ../modules/ssh
    ../modules/direnv
    ../modules/lsd
    ../modules/tmux
    ../modules/neovim
    # ../modules/weechat
    # ../modules/clojure
    # ../modules/emacs
    # ../modules/nnn
    ../modules/yazi
    # ../modules/kakoune
    ../modules/helix
    ../modules/nix-index
    ../modules/docker
  ];

  home.packages = with pkgs; [
    curl
    htop
    imgcat

    # dev
    entr
    mosh
    ripgrep
    jq
    fx
    openssl
    devenv

    (lib.mkDefault (pkgs.writeShellScriptBin "get-theme-default" ''
      echo dark
    ''))
    (pkgs.writeShellScriptBin "p" ''
      set -eu -o pipefail
      if [ "$#" -eq 0 ]; then
        echo "usage: $0 [editor cmd line]" >&2
        echo "       run a command in a zoxide directory" >&2
        exit 1
      fi
      edit="$@"

      dir=$(${pkgs.zoxide}/bin/zoxide query -i)
      cd "$dir"

      if [ -f ".envrc" ]; then
        ${pkgs.direnv}/bin/direnv exec . $edit
      else
        $edit
      fi
    '')
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
  programs.less.enable = true;
  programs.fd.enable = true;
  programs.jq.enable = true;
  programs.fzf.enable = true;
  programs.lsd.enable = true;
  programs.dircolors.enable = true;
  programs.zoxide.enable = true;
  programs.pay-respects.enable = true;
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

  xdg.systemDirs.data = ["${config.home.homeDirectory}/.nix-profile/share/applications"];

  xdg.mime.enable = true;
  xdg.mimeApps.enable = true;
}
