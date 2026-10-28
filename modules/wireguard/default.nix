{ config, lib, ... }:
{
  networking.wireguard.interfaces.wg0 = {
    ips = [ "10.2.0.2/32" ];
    mtu = 1420;
    privateKeyFile = config.age.secrets.wireguard.path;
    allowedIPsAsRoutes = false;

    peers = [
      {
        name = "proton";
        publicKey = "28hrybwV/NiiMXvl1ynBvDvEvs1m8ABUzyvkQ7+ST3I=";
        endpoint = "146.70.198.34:51820";
        allowedIPs = [ "0.0.0.0/0" ];
        persistentKeepalive = 25;
      }
    ];

    postSetup = builtins.readFile ./up.sh;
    postShutdown = "ip -4 rule del priority 10000 from 10.2.0.2/32 table 51820";
  };

  # NOTE: key loads only at interface setup; new key needs a restart
  systemd.services.wireguard-wg0.restartTriggers = [ config.age.secrets.wireguard.file ];

  # NOTE: strict rpfilter drops wg0 replies; their reverse route is in main
  networking.firewall.checkReversePath = "loose";

  # NOTE: stops NetworkManager and GUI shells from removing wg0
  networking.networkmanager.unmanaged = [ "interface-name:wg0" ];

  # NOTE: peer can handshake but forward nothing; stock ping alerts detect it
  services.netdata.configDir."go.d/ping.conf" = ./egress-ping.conf;
  # NOTE: raw ICMP; upstream installs set this on go.d.plugin with setcap
  systemd.services.netdata.serviceConfig = lib.mkIf config.services.netdata.enable {
    AmbientCapabilities = [ "CAP_NET_RAW" ];
  };
}
