{
  pkgs,
  ...
}:
{
  home.packages = [
    (pkgs.weechat.override {
      configure =
        _:
        {
          scripts = with pkgs.weechatScripts; [
            wee-slack
            # weechat-matrix
            multiline
          ];
        };
    })
  ];
  #
  #   home.sessionVariables = {
  #     WEECHAT_HOME = "${config.xdg.configHome}/weechat";
  #   };
}
