{
  pkgs,
  lib,
  ...
}:
{
  services.opensnitch.rules.systemd-resolved = {
    name = "systemd-resolved";
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
