{
  nixpkgs-unstable,
  pkgs,
  lib,
  ...
}:
let
  podman = lib.getExe nixpkgs-unstable.podman;
  # Wrapper that puts containers on the podman bridge network so Traefik can
  # reach them.  Only affects run/create; other subcommands pass through.
  podman-bridged = nixpkgs-unstable.writeShellScriptBin "podman-bridged" ''
    set -euo pipefail
    export PODMAN_COMPOSE_PROVIDER=${lib.getExe nixpkgs-unstable.podman-compose}
    exec ${podman} "$@"
  '';

  podman-compose = nixpkgs-unstable.writeShellScriptBin "podman-compose" ''
    set -euo pipefail
    export PODMAN_COMPOSE_PROVIDER=${lib.getExe nixpkgs-unstable.podman-compose}

    exec "${podman}" compose "$@"
  '';

  devcontainer-podman = nixpkgs-unstable.writeShellScriptBin "devcontainer" ''
    set -euo pipefail
    args=()
    docker_path=false
    for arg in "$@"; do
      args+=("$arg")
      if [ "$docker_path" = false ] && { [ "$arg" = "up" ] || [ "$arg" = "build" ]; }; then
        args+=("--docker-path" "${lib.getExe podman-bridged}")
        args+=("--docker-compose-path" "${lib.getExe podman-compose}")
        docker_path=true
      fi
    done
    exec ${lib.getExe nixpkgs-unstable.devcontainer} "''${args[@]}"
  '';
in
{
  imports = [ ../traefik ];

  services.traefik = {
    enable = true;
    staticConfigOptions = {
      entryPoints.web.address = ":80";
      api = {
        dashboard = true;
        insecure = true;
      };
      providers.docker = {
        exposedByDefault = false;
        defaultRule = "Host(`{{ .ContainerName }}.localhost`)";
      };
    };
    dynamicConfigOptions = {
      http.routers.dashboard = {
        rule = "Host(`traefik.localhost`)";
        service = "api@internal";
      };
    };
  };

  home.packages = with nixpkgs-unstable; [
    lazydocker
    podman-tui
    devcontainer-podman
    podman-compose
  ];

  # not using home-manager
  # services.podman.enable = true;
  xdg.configFile."containers/policy.json".source = "${pkgs.skopeo.src}/default-policy.json";

  programs.fish.completions = {
    podman.body = ''
      ${nixpkgs-unstable.podman}/bin/podman completion fish | source
    '';
  };
}
