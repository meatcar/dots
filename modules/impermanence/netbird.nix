{
  config,
  lib,
  ...
}:
{
  environment.persistence."/persist".directories = lib.mapAttrsToList (_: client: {
    directory = client.dir.state;
    user = if client.hardened then client.user.name else "root";
    group = if client.hardened then client.user.group else "root";
    mode = "0700";
  }) config.services.netbird.clients;
}
