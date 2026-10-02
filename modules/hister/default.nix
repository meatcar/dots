{
  services.hister = {
    enable = true;
    dataDir = "/var/lib/hister";
    settings.server.address = "127.0.0.1:4433";
  };
}
