{
  config,
  pkgs,
  lib,
  ...
}:
{
  services.opensnitch.rules.systemd-resolved = lib.mkIf config.services.resolved.enable {
    name = "systemd-resolved";
    enabled = true;
    created = "1970-01-01T00:00:00Z";
    action = "allow";
    duration = "always";
    operator = {
      type = "list";
      operand = "list";
      list = [
        {
          type = "simple";
          operand = "process.path";
          data = "${lib.getBin pkgs.systemd}/lib/systemd/systemd-resolved";
        }
        {
          type = "regexp";
          operand = "dest.ip";
          data = "^(8\\.8\\.8\\.8|1\\.1\\.1\\.1)$";
        }
        {
          type = "simple";
          operand = "dest.port";
          data = "853";
        }
      ];
    };
  };
}
