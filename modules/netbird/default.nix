# Work and personal NetBird networks, up at the same time.
# DNS: each daemon sets match domains on its own resolved link, next to tailscale0.
# Routing order: wg0 (90), Tailscale routes (100), main incl. personal (105), work (110), Tailscale exit node (5270).
# NOTE: Personal uses legacy routing, so a personal exit node also carries the other VPN tunnels.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.netbird;

  client = {
    hardened = true;
    # NOTE: config.d merges into config.json; a removed key keeps its old value.
    config = {
      DisableDNS = false;
      DisableClientRoutes = false;
      # NOTE: NetBird never turns ip_forward back off; the work admin gets no routing peer.
      DisableServerRoutes = true;
      # NOTE: Off by default on Linux; restarts the engine when the default route changes.
      NetworkMonitor = true;
    };
    environment = {
      # NOTE: Pins each daemon to config.json; `sudo netbird up` can't switch to root's profile.
      NB_DISABLE_PROFILES = "true";
      # NOTE: /etc/ssh is read-only under hardening.
      NB_DISABLE_SSH_CONFIG = "true";
    };
  };

  # NOTE: Default deny for forwards into and out of NetBird. Personal peers may route only to the internet.
  forwardChain = "netbird-forward";
  router = cfg.clients.personal.interface;
  netbirdInterfaces = lib.mapAttrsToList (_: c: c.interface) cfg.clients;
  uplinks = [
    "wl+"
    "en+"
  ];
  privateRanges = {
    "4" = [
      "10.0.0.0/8"
      "172.16.0.0/12"
      "192.168.0.0/16"
      "100.64.0.0/10"
      "169.254.0.0/16"
    ];
    "6" = [
      "fc00::/7"
      "fe80::/10"
    ];
  };
  forwardRules =
    family:
    pkgs.writeText "${forwardChain}-v${family}.rules" (
      lib.concatLines (
        [
          "*mangle"
          ":${forwardChain} - [0:0]"
          "-A ${forwardChain} -m conntrack --ctstate ESTABLISHED,RELATED -j RETURN"
        ]
        ++ map (i: "-A ${forwardChain} -o ${i} -j DROP") netbirdInterfaces
        ++ map (d: "-A ${forwardChain} -i ${router} -d ${d} -j DROP") privateRanges.${family}
        ++ map (o: "-A ${forwardChain} -i ${router} -o ${o} -j RETURN") uplinks
        ++ map (i: "-A ${forwardChain} -i ${i} -j DROP") netbirdInterfaces
        ++ [ "COMMIT" ]
      )
    );
  forwardPolicy = pkgs.writeShellApplication {
    name = "netbird-forward-policy";
    runtimeInputs = [ pkgs.iptables ];
    text = builtins.readFile ./forward-policy.sh;
  };

  routePrecedence = pkgs.writeShellApplication {
    name = "vpn-route-precedence";
    runtimeInputs = [ pkgs.iproute2 ];
    text = builtins.readFile ./route-precedence.sh;
  };
in
{
  services.netbird = {
    enable = true;
    # NOTE: Sets loose rp_filter, which exit nodes need.
    useRoutingFeatures = "client";
    clients.default = lib.recursiveUpdate client {
      port = 51821;
    };
    clients.personal = lib.recursiveUpdate client {
      port = 51822;
      interface = "wt-personal";
      config = {
        DisableServerRoutes = false;
        # NOTE: Drops forwards to subnets on local interfaces; re-read when the default route changes.
        BlockLANAccess = true;
      };
      environment = {
        # NOTE: Default table "netbird" is deleted on startup by every daemon.
        NB_NFTABLES_TABLE = "netbird-personal";
        # NOTE: Only one XDP program fits on lo; the default client owns it.
        NB_DISABLE_EBPF_WG_PROXY = "true";
        # NOTE: Advanced routing shares one table and its rules; each daemon flushes them on stop.
        NB_USE_LEGACY_ROUTING = "true";
      };
    };
  };

  systemd.services =
    lib.mapAttrs' (
      _: c:
      lib.nameValuePair c.service.name {
        # NOTE: resolved queries port 53 only. Without this, hardened DNS needs XDP on lo.
        serviceConfig.AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
        # NOTE: The daemon starts the profile named here; config.d only reaches config.json.
        preStart = "rm -f ${c.dir.state}/active_profile.json";
      }
    ) cfg.clients
    // {
      vpn-route-precedence = lib.mkIf config.services.tailscale.enable {
        description = "Route Tailscale ahead of NetBird";
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart = "${lib.getExe routePrecedence} add";
          ExecStop = "${lib.getExe routePrecedence} del";
        };
      };
    };

  # NOTE: NetBird accepts wt* first in every filter chain it does not own; mangle is out of its reach.
  networking.firewall.extraCommands = lib.escapeShellArgs [
    (lib.getExe forwardPolicy)
    forwardChain
    (forwardRules "4")
    (forwardRules "6")
  ];

  users.users.meatcar.extraGroups = lib.mapAttrsToList (_: c: c.user.group) (
    lib.filterAttrs (_: c: c.hardened) cfg.clients
  );

  # NOTE: Include completions without replacing the service's CLI wrapper.
  environment.systemPackages = [ (lib.lowPrio cfg.package) ];
}
