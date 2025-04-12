{...}: {
  services.printing.enable = true;
  services.printing.drivers = [];
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
}
