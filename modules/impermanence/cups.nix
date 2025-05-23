{
  config,
  lib,
  ...
}:
{
  environment.persistence."/persist".files = lib.mkIf config.services.printing.enable [
    "/etc/printcap"
  ];
  environment.persistence."/persist".directories = lib.mkIf config.services.printing.enable [
    "/var/cache/cups"
    "/var/lib/cups"
  ];
}
