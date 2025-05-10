let
  # FIXME: https://github.com/ryantm/agenix/issues/300
  xdgRuntimeDir = "/run/user/1000";
in
{
  imports = [ ../../../secrets/module.nix ];
  age.secretsDir = "${xdgRuntimeDir}/agenix";
}
