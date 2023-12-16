{
  pkgs,
  config,
  ...
}: {
  home.packages = [
    (pkgs.weechat.override {
      configure = {availablePlugins, ...}: {
        scripts = with pkgs.weechatScripts; [wee-slack weechat-matrix multiline];
      };
    })
  ];
  #
  #   home.sessionVariables = {
  #     WEECHAT_HOME = "${config.xdg.configHome}/weechat";
  #   };
}
