# Work and personal NetBird networks, up at the same time.
{ config, lib, ... }:
let
  cfg = config.services.netbird;
  client = {
    openInternalFirewall = false;
    # NOTE: Leave DNS and subnet/exit routing to Tailscale and wg0.
    # Both daemons would also share one routing table and fwmark.
    config = {
      DisableDNS = true;
      DisableClientRoutes = true;
      DisableServerRoutes = true;
    };
  };
in
{
  services.netbird = {
    enable = true;
    clients.default = client // {
      port = 51821;
    };
    clients.personal = client // {
      port = 51822;
      interface = "wt-personal";
      environment = {
        # NOTE: Default table "netbird" is deleted on startup by every daemon.
        NB_NFTABLES_TABLE = "netbird-personal";
        # NOTE: Only one XDP program fits on lo; the default client owns it.
        NB_DISABLE_EBPF_WG_PROXY = "true";
      };
    };
  };

  users.users.meatcar.extraGroups = lib.mapAttrsToList (_: c: c.user.group) (
    lib.filterAttrs (_: c: c.hardened) cfg.clients
  );

  # NOTE: Include completions without replacing the service's CLI wrapper.
  environment.systemPackages = [ (lib.lowPrio cfg.package) ];
}
