{
  config,
  lib,
  pkgs,
  specialArgs,
  ...
}:
{
  imports = [
    ../modules/nix.nix
    ../modules/nix-your-shell
    ../modules/man
    ../modules/git
    ../modules/fish
    ../modules/starship
    ../modules/ssh
    ../modules/direnv
    ../modules/bat
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

  home.packages =
    with pkgs;
    [
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

      (lib.mkDefault (
        pkgs.writeShellScriptBin "get-theme-default" ''
          echo dark
        ''
      ))
    ]
    ++ [
      # FIXME: fails to build from stable, use unstable for now
      specialArgs.nixpkgs-unstable.devenv
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

  xdg.systemDirs.data = [ "${config.home.homeDirectory}/.nix-profile/share/applications" ];

  xdg.mime.enable = true;
  xdg.mimeApps.enable = true;
}
