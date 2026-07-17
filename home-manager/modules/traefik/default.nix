# Home-manager traefik module. Runs traefik as a rootless podman quadlet on
# the podman network so it can reach other containers by internal IP.
{
  config,
  nixpkgs-unstable,
  lib,
  ...
}:
let
  cfg = config.services.traefik;
  pkgs = nixpkgs-unstable;

  format = pkgs.formats.toml { };

  dynamicConfigFile =
    if cfg.dynamicConfigFile == null then
      format.generate "traefik-dynamic.toml" cfg.dynamicConfigOptions
    else
      cfg.dynamicConfigFile;

  staticConfigFile =
    if cfg.staticConfigFile == null then
      format.generate "traefik.toml" (
        lib.recursiveUpdate cfg.staticConfigOptions {
          providers.file.filename = "/etc/traefik/dynamic.toml";
        }
      )
    else
      cfg.staticConfigFile;

  # nix-built image: provenance via nixpkgs instead of a mutable registry tag
  image = pkgs.dockerTools.buildLayeredImage {
    name = "localhost/traefik";
    tag = "latest";
    contents = [
      cfg.package
      pkgs.cacert
    ];
    config = {
      Entrypoint = [ "/bin/traefik" ];
      Env = [ "SSL_CERT_FILE=/etc/ssl/certs/ca-bundle.crt" ];
    };
  };
in
{
  imports = [ ../quadlet ];

  options.services.traefik = {
    enable = lib.mkEnableOption "Traefik reverse proxy";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.traefik;
      defaultText = "nixpkgs-unstable.traefik";
      description = "Traefik package the container image is built from.";
    };

    staticConfigFile = lib.mkOption {
      default = null;
      type = lib.types.nullOr lib.types.path;
      description = ''
        Path to traefik's static configuration to use.
        Takes precedence over `staticConfigOptions` and `dynamicConfigOptions`.
      '';
    };

    staticConfigOptions = lib.mkOption {
      inherit (format) type;
      default = {
        entryPoints.web.address = ":80";
      };
      description = "Static configuration for Traefik.";
    };

    dynamicConfigFile = lib.mkOption {
      default = null;
      type = lib.types.nullOr lib.types.path;
      description = ''
        Path to traefik's dynamic configuration to use.
        Takes precedence over `dynamicConfigOptions`.
      '';
    };

    dynamicConfigOptions = lib.mkOption {
      inherit (format) type;
      default = { };
      description = "Dynamic configuration for Traefik.";
    };

    networks = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ "podman" ];
      description = ''
        Container networks to join. Definitions merge, so service modules can
        append their own networks (e.g. a quadlet network ref).
      '';
    };

    networkAliases = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = ''
        Extra DNS names traefik answers to on joined networks, letting
        containers reach fronted services through traefik by the same
        hostname hosts use.
      '';
    };

    ports = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ "127.0.0.1:80:80" ];
      description = "Port mappings for the traefik container.";
    };

    extraLabels = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Extra labels to set on the traefik container.";
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation.quadlet.images.traefik.imageConfig = {
      image = "docker-archive:${image}";
      tag = "localhost/traefik:latest";
    };

    virtualisation.quadlet.containers.traefik = {
      unitConfig = {
        After = [ "podman.socket" ];
        Requires = [ "podman.socket" ];
      };
      serviceConfig = {
        Restart = "on-failure";
        RestartSec = 5;
      };
      containerConfig = {
        image = config.virtualisation.quadlet.images.traefik.ref;
        name = "traefik";
        inherit (cfg) networks networkAliases;
        publishPorts = cfg.ports;
        volumes = [
          # FIXME: full API access; a compromised traefik can spawn containers
          # as this uid (:ro doesn't restrict the API). Only the docker
          # provider (devcontainer auto-routing) needs it. Before exposing
          # traefik to untrusted workloads (agent sandboxes): front the socket
          # with an allowlisting filter (e.g. wollomatic/socket-proxy, GET
          # /containers + /events only), and never join traefik to a sandbox
          # network while it holds the raw socket.
          "%t/podman/podman.sock:/var/run/docker.sock:ro"
          "${staticConfigFile}:/etc/traefik/traefik.toml:ro"
          "${dynamicConfigFile}:/etc/traefik/dynamic.toml:ro"
        ];
        labels = cfg.extraLabels;
      };
    };
  };
}
