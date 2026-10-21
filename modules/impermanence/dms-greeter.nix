{
  config,
  lib,
  ...
}:
{
  # memory.json here holds the last user, so the greeter preselects it
  config = lib.mkIf (config.programs ? dms-greeter && config.programs.dms-greeter.enable) {
    environment.persistence."/persist".directories = [
      {
        directory = "/var/lib/dms-greeter";
        user = "dms-greeter";
        group = "dms-greeter";
        mode = "0750";
      }
    ];
  };
}
