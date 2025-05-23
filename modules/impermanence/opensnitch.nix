{
  config,
  lib,
  ...
}:
{
  environment.persistence."/persist".directories = lib.mkIf config.services.opensnitch.enable [
    "/var/lib/opensnitch/rules"
  ];
}
