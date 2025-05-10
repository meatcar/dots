{
  config,
  pkgs,
  lib,
  ...
}:
let
  name = "services-geoclue";
in
{
  services.opensnitch.rules.${name} = {
    inherit name;
    enabled = true;
    action = "allow";
    duration = "always";
    operator = {
      type = "list";
      operand = "list";
      list = [
        {
          type = "simple";
          operand = "process.path";
          data = "${lib.getExe pkgs.geoclue2}";
        }
        {
          type = "regexp";
          operand = "dest.host";
          data = config.services.geoclue2.geoProviderUrl;
        }
        {
          type = "simple";
          operand = "dest.port";
          data = "443";
        }
      ];
    };
  };
}
