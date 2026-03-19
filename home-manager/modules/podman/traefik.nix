{
  nixpkgs-unstable,
  lib,
  ...
}:
let
  podmanBin = "${nixpkgs-unstable.podman}/bin/podman";
in
{
  systemd.user.services.traefik = {
    Unit = {
      Description = "Traefik reverse proxy for local containers";
      After = [ "podman.socket" ];
      Requires = [ "podman.socket" ];
    };
    Service = {
      ExecStartPre = "-${podmanBin} rm -f traefik";
      ExecStart = lib.concatStringsSep " " [
        "${podmanBin} run"
        "--name traefik"
        "--rm"
        "--network podman"
        "-p 127.0.0.1:80:80"
        "-v %t/podman/podman.sock:/var/run/docker.sock:ro"
        "-l traefik.http.routers.dashboard.rule=Host(`traefik.localhost`)"
        "-l traefik.http.routers.dashboard.service=api@internal"
        "docker.io/traefik:v3"
        "--entrypoints.web.address=:80"
        "--providers.docker.exposedByDefault=true"
        "\"--providers.docker.defaultRule=Host(`{{ .ContainerName }}.localhost`)\""
        "--api.dashboard=true"
      ];
      ExecStop = "${podmanBin} stop traefik";
      Restart = "on-failure";
      RestartSec = 5;
    };
    Install.WantedBy = [ "default.target" ];
  };
}
