{
  config,
  lib,
  pkgs,
  nixpkgs-unstable,
  ...
}:
{
  options.me.PRJ_ROOT = lib.mkOption {
    type = lib.types.str;
    default = "${config.home.homeDirectory}/git/hub/meatcar/dots/dots-default";
    description = "Absolute filesystem path to the working copy of this flake (PRJ_ROOT per prj-spec; used by mkOutOfStoreSymlink targets).";
  };

  imports = [
    ../modules/nix.nix
    ../modules/nix-your-shell
    ../modules/man
    ../modules/git
    ../modules/hunk
    ../modules/jujutsu
    ../modules/fish
    ../modules/starship
    ../modules/ssh
    ../modules/direnv
    ../modules/bat
    ../modules/lsd
    ../modules/btop
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
    # ../modules/docker
    ../modules/podman
    ../modules/npm
    ../modules/bun
    # ../modules/junction
    ../modules/audio-record
  ];

  config = {
    home.packages =
      with pkgs;
      [
        curl
        htop
        imgcat
        p7zip-rar

        # dev
        entr
        mosh
        ripgrep
        jq
        fx
        openssl
        q # dns query tool

        (lib.mkDefault (
          pkgs.writeShellScriptBin "get-theme-default" ''
            echo dark
          ''
        ))
      ]
      ++ [
        # FIXME: fails to build from stable, use unstable for now
        nixpkgs-unstable.devenv
      ];

    xdg.enable = true;
    home.sessionVariables = {
      EDITOR = "nvim";
      NOTES_DIR = "~/Sync/notes";
      LESS = "-R --mouse";
      DO_NOT_TRACK = "1";
      DISABLE_TELEMETRY = "1";
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
  };
}
