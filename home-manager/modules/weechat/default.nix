{ pkgs, config, ... }: {
  home.packages = [ pkgs.weechat ];

  home.sessionVariables = {
    WEECHAT_HOME = "${config.xdg.configHome}/weechat";
  };

  nixpkgs.config.packageOverrides = pkgs: {
    weechat = pkgs.weechat.override {
      configure = { availablePlugins, ... }: {
        scripts = with pkgs.weechatScripts; [ wee-slack weechat-matrix multiline ];
      };
    };

  };
}
