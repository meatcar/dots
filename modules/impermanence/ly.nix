{
  config,
  lib,
  ...
}:
{
  environment.persistence."/persist".files = lib.mkIf config.services.displayManager.ly.enable [
    "/etc/ly/save.txt"
  ];
}
