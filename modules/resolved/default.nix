{ config, ... }:
{
  networking.networkmanager.dns = "systemd-resolved";
  services.resolved = {
    enable = true;
    # dnsovertls = "true";
    domains = [ "~." ];
    fallbackDns = config.networking.nameservers;
  };
}
