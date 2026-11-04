# Work and personal NetBird networks, up at the same time.
# DNS: each daemon sets match domains on its own resolved link, next to tailscale0.
{ config, lib, ... }:
let
  cfg = config.services.netbird;
  client = {
    hardened = true;
    openInternalFirewall = false;
    # NOTE: Routes stay off: both daemons share one routing table and fwmark.
    # NOTE: config.d merges into config.json; a removed key keeps its old value.
    config = {
      DisableDNS = false;
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

  # NOTE: resolved queries port 53 only. Without this, hardened DNS needs XDP on lo.
  systemd.services = lib.mapAttrs' (
    _: c:
    lib.nameValuePair c.service.name {
      serviceConfig.AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
    }
  ) cfg.clients;

  users.users.meatcar.extraGroups = lib.mapAttrsToList (_: c: c.user.group) (
    lib.filterAttrs (_: c: c.hardened) cfg.clients
  );

  # NOTE: Include completions without replacing the service's CLI wrapper.
  environment.systemPackages = [ (lib.lowPrio cfg.package) ];
}
