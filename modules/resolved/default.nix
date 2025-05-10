{ config, ... }:
{
  imports = [ ../opensnitch/rules/systemd/resolved.nix ];
  services.resolved = {
    enable = true;
    dnsovertls = "true";
    domains = [ "~." ];
    fallbackDns = config.networking.nameservers;
  };
  # FIX for https://github.com/systemd/systemd/issues/35654
  systemd.services.systemd-resolved = {
    wantedBy = [ "network-online.target" ];
    after = [ "network-online.target" ];
    partOf = [ "network-online.target" ];
  };
}
