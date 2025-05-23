{
  config,
  pkgs,
  lib,
  ...
}:
let
  name = "1password";
in
{
  services.opensnitch.rules.${name} = lib.mkIf config.programs._1password.enable {
    inherit name;
    enabled = true;
    action = "allow";
    created = "1970-01-01T00:00:00Z";
    duration = "always";
    operator = {
      type = "simple";
      operand = "process.path";
      data = "${pkgs._1password}/share/1password/1password";
    };
  };
}
