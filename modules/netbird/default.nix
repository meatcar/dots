{ config, lib, ... }:
let
  cfg = config.services.netbird;
in
{
  services.netbird = {
    enable = true;
    clients.default = {
      port = 51821;
      openInternalFirewall = false;
      # NOTE: Leave DNS and subnet/exit routing to Tailscale and wg0.
      config = {
        DisableDNS = true;
        DisableClientRoutes = true;
        DisableServerRoutes = true;
      };
    };
  };

  # NOTE: Include completions without replacing the service's CLI wrapper.
  environment.systemPackages = [ (lib.lowPrio cfg.package) ];
}
