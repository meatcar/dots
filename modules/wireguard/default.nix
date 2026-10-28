{ config, ... }:
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

  # strict rpfilter drops wg0 replies; reverse route is the main table
  networking.firewall.checkReversePath = "loose";

  # keep nm (and gui shells driving it) from tearing the interface down
  networking.networkmanager.unmanaged = [ "interface-name:wg0" ];
}
