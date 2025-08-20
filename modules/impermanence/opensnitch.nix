{
  config,
  lib,
  ...
}:
{
  environment.persistence."/persist".directories = lib.mkIf config.services.opensnitch.enable [
    {
      directory = config.services.opensnitch.settings.Rules.Path;
      mode = "0755";
    }
  ];
}
