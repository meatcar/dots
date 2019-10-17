{ pkgs, ... }: {
  home.packages = [ pkgs.weechat ];

  nixpkgs.config.packageOverrides = pkgs: {
    weechat = pkgs.weechat.override {
      configure = { availablePlugins, ... }: {
        plugins = builtins.attrValues {
          inherit (availablePlugins) perl tcl ruby guile lua;
          python = (
            availablePlugins.python.withPackages (
              packages: [ packages.websocket_client ] # needed for slack.py
            )
          );
        };
      };
    };

  };
}
