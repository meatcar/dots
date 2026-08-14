{ config, ... }:
{
  home.sessionPath = [ "${config.xdg.cacheHome}/.bun/bin" ];
  programs.bun.enable = true;
  programs.bun.settings = {
    telemetry = false;
  };
}
