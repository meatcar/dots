{ config, pkgs, ... }:
{
  networking.networkmanager.dns = "systemd-resolved";
  services.resolved = {
    enable = true;
    # dnsovertls = "true";
    settings.Resolve = {
      # beats link's DefaultRoute, so DHCP-provided DNS is never used.
      # Use hotspot-portal-dns-passthrough script to bypass
      Domains = [ "~." ];
      FallbackDNS = config.networking.nameservers;
    };
  };

  environment.systemPackages = [
    (pkgs.writeShellApplication {
      name = "hotspot-portal-dns-passthrough";
      runtimeInputs = with pkgs; [
        bubblewrap
        coreutils # cat, head, id, mkdir, mktemp, printf, rm, tr
        curl
        gnugrep
        gnused
        iproute2
        networkmanager # nmcli
        systemd # resolvectl
      ];
      text = builtins.readFile ./hotspot-portal-dns-passthrough.sh;
    })
  ];
}
