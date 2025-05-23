{
  config,
  pkgs,
  lib,
  ...
}:
let
  name = "tailscale";
in
{
  services.opensnitch.rules.${name} = lib.mkIf config.services.tailscale.enable {
    inherit name;
    enabled = true;
    created = "1970-01-01T00:00:00Z";
    action = "allow";
    duration = "always";
    operator = {
      type = "simple";
      operand = "process.path";
      data = "${pkgs.tailscale}/bin/tailscaled-wrapped";
    };
  };
}
