{
  pkgs,
  ...
}:
let
  name = "activitywatch";
in
{
  services.opensnitch.rules.${name} = {
    inherit name;
    enabled = true;
    action = "allow";
    created = "1970-01-01T00:00:00Z";
    duration = "always";
    operator = {
      type = "simple";
      operand = "process.path";
      data = "${pkgs.awatcher}/bin/awatcher";
    };
  };
}
