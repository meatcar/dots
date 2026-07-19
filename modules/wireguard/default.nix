{ config, ... }:
{
  # up but idle; sockets bound to wg0 (10.2.0.2) route through it, rest untouched
  networking.wg-quick.interfaces.wg0 = {
    configFile = config.age.secrets.wireguard.path;
  };

  # strict rpfilter drops wg0 replies; reverse route is the main table
  networking.firewall.checkReversePath = "loose";

  # keep nm (and gui shells driving it) from tearing the interface down
  networking.networkmanager.unmanaged = [ "interface-name:wg0" ];
}
