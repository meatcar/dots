{
  config,
  lib,
  ...
}: {
  environment.persistence."/persist".directories = lib.mkIf config.services.tailscale.enable ["/var/lib/tailscale"];
}
