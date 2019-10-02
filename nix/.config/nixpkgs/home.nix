{ config, pkgs, ... }:

{
  home.packages = builtins.attrValues {
    inherit (pkgs)
      htop mosh broot neomutt isync msmtp ripgrep jq rootlesskit docker
      docker-compose entr weechat nox nixfmt binutils gcc gnumake openssl pkgconfig;
  };

  home.sessionVariables.XDG_RUNTIME_DIR = "/var/run/user/$UID";
  xdg.enable = true;
  fonts.fontconfig.enable = true;
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.man.enable = true;

  imports = [ ./pkgs/git ./pkgs/fish ./pkgs/tmux ./pkgs/neovim ./pkgs/kakoune ];

  nixpkgs.config.packageOverrides = pkgs: {

    weechat = pkgs.weechat.override {
      configure = { availablePlugins, ... }: {
        plugins = builtins.attrValues {
          inherit (availablePlugins) perl tcl ruby guile lua;
          python = (availablePlugins.python.withPackages (packages:
            [
              packages.websocket_client # needed for slack.py
            ]));
        };
      };
    };

  };
}
