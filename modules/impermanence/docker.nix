{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.virtualisation.docker.enable {
    environment.persistence."/persist".directories = [
      "/var/lib/docker"
    ];
  };
}
