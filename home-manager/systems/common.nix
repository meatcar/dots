{
  config,
  lib,
  pkgs,
  nixpkgs-unstable,
  ...
}:
let
  userPath = lib.concatStringsSep ":" (
    [ "${config.home.profileDirectory}/bin" ]
    ++ config.home.sessionPath
    ++ [
      "/run/wrappers/bin"
      "/run/current-system/sw/bin"
      "/etc/profiles/per-user/${config.home.username}/bin"
      "/nix/var/nix/profiles/default/bin"
      "/usr/local/bin"
      "/usr/bin"
      "/bin"
    ]
  );
in
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
    ../modules/glow
    ../modules/lsd
    ../modules/btop
    ../modules/tmux
    ../modules/neovim
    ../modules/lf
    ../modules/vifm
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

    xdg = {
      enable = true;
      localBinInPath = true;
      # NOTE: 90 sorts after NixOS's /etc/environment.d/50-systemd-path.conf.
      configFile."environment.d/90-home-manager-path.conf".text = "PATH=${userPath}\n";
    };
    home.sessionPath = [ "${config.home.homeDirectory}/bin" ];
    home.activation.setSystemdUserPath =
      lib.hm.dag.entryBetween [ "reloadSystemd" ] [ "linkGeneration" ]
        ''
          runtimeDir="''${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"
          if [ -S "$runtimeDir/bus" ]; then
            run env XDG_RUNTIME_DIR="$runtimeDir" ${pkgs.systemd}/bin/systemctl --user set-environment ${lib.escapeShellArg "PATH=${userPath}"}
          fi
        '';
    # NOTE: dbus-broker silently skips service dirs missing at scan time, and its
    # inotify mask carries no IN_CREATE, so symlinked-in service files are never
    # noticed either. Impermanence guarantees both at boot. Reload is config-only.
    home.activation.reloadDbusServices = lib.hm.dag.entryAfter [ "linkGeneration" "installPackages" ] ''
      runtimeDir="''${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"
      if [ -S "$runtimeDir/bus" ]; then
        run env XDG_RUNTIME_DIR="$runtimeDir" ${pkgs.systemd}/bin/systemctl --user reload dbus.service \
          || echo "warning: could not reload the session bus; D-Bus activation of new apps needs a re-login" >&2
      fi
    '';
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
