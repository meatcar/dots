{ pkgs, config, ... }: {
  home.packages = [ pkgs.weechat ];

  home.sessionVariables = {
    WEECHAT_HOME = "${config.xdg.configHome}/weechat";
  };

  nixpkgs.config.packageOverrides = pkgs: {
    weechat = pkgs.weechat.override {
      configure = { availablePlugins, ... }: {
        plugins = builtins.attrValues {
          inherit (availablePlugins) tcl ruby guile lua;
          python = (
            availablePlugins.python.withPackages (
              p: [ p.websocket_client ] # needed for slack.py
            )
          );
          perl = (
            availablePlugins.perl.withPackages (
              p: [ p.PodParser ] # needed for multiline.pl
            )
          );
        };
      };
    };

  };
}
