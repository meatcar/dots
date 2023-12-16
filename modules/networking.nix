{
  config,
  lib,
  pkgs,
  ...
}: {
  networking = {
    wireless.iwd.enable = true;
    nameservers = ["127.0.0.1" "8.8.8.8"];
    # fail-over on public hotspots, less secure but I'm ok with that.
    resolvconf.extraConfig = "resolv_conf_local_only=NO\n";
  };

  services.dnscrypt-proxy2 = {
    enable = true;
    settings = {
      sources.public-resolvers = {
        urls = ["https://download.dnscrypt.info/resolvers-list/v2/public-resolvers.md"];
        cache_file = "public-resolvers.md";
        minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
        refresh_delay = 72;
      };
      require_dnssec = true;
      require_nolog = true;
      require_nofilter = true;
    };
  };
  services.udev = {
    extraRules = ''
      SUBSYSTEM=="misc", ACTION=="add|remove", DEVNAME=="/dev/rfkill",RUN+="${pkgs.acl}/bin/setfacl -m u:meatcar:rw /dev/rfkill"
    '';
  };
}
