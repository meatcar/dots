{
  config,
  pkgs,
  lib,
  ...
}:
let
  name = "systemd-timesyncd";
in
{
  services.opensnitch.rules.${name} = lib.mkIf config.services.automatic-timezoned.enable {
    inherit name;
    enabled = true;
    action = "allow";
    created = "1970-01-01T00:00:00Z";
    duration = "always";
    operator = {
      type = "simple";
      operand = "process.path";
      data = "${lib.getBin pkgs.systemd}/lib/systemd/systemd-timesyncd";
    };
  };
}
