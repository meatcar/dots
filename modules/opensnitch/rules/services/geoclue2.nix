{
  config,
  pkgs,
  lib,
  ...
}:
let
  name = "services-geoclue2";
in
{
  services.opensnitch.rules.${name} = lib.mkIf config.services.geoclue2.enable {
    inherit name;
    enabled = true;
    action = "allow";
    created = "1970-01-01T00:00:00Z";
    duration = "always";
    operator = {
      type = "list";
      operand = "list";
      list = [
        {
          type = "simple";
          operand = "process.path";
          data = "${pkgs.geoclue2}/lib/exec/geoclue-wrapped";
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
