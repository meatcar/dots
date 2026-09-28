{
  config,
  lib,
  ...
}:
let
  name = "1password";
in
{
  services.opensnitch.rules.${name} = lib.mkIf config.programs._1password-gui.enable {
    inherit name;
    enabled = true;
    action = "allow";
    created = "1970-01-01T00:00:00Z";
    duration = "always";
    operator = {
      type = "simple";
      operand = "process.path";
      data = "${config.programs._1password-gui.package}/share/1password/1password";
    };
  };
}
