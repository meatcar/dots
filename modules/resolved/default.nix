{ config, ... }:
{
  networking.networkmanager.dns = "systemd-resolved";
  services.resolved = {
    enable = true;
    # dnsovertls = "true";
    settings.Resolve = {
      Domains = [ "~." ];
      FallbackDNS = config.networking.nameservers;
    };
  };
}
