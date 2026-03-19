# Home-manager traefik module. Runs traefik as a podman container on the
# podman network so it can reach other containers by internal IP.
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
  podman = lib.getExe pkgs.podman;

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
in
{
  options.services.traefik = {
    enable = lib.mkEnableOption "Traefik reverse proxy";

    image = lib.mkOption {
      type = lib.types.str;
      default = "docker.io/traefik:v3";
      description = "Traefik container image to use.";
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

    network = lib.mkOption {
      type = lib.types.str;
      default = "podman";
      description = "Container network to join.";
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
    xdg.configFile."traefik/traefik.toml".source = staticConfigFile;
    xdg.configFile."traefik/dynamic.toml".source = dynamicConfigFile;

    systemd.user.services.traefik = {
      Unit = {
        Description = "Traefik reverse proxy";
        After = [ "podman.socket" ];
        Requires = [ "podman.socket" ];
      };
      Service = {
        ExecStartPre = "-${podman} rm -f traefik";
        ExecStart = lib.concatStringsSep " " (
          [
            "${podman} run"
            "--name traefik"
            "--rm"
            "--network ${cfg.network}"
          ]
          ++ map (p: "-p ${p}") cfg.ports
          ++ [
            "-v %t/podman/podman.sock:/var/run/docker.sock:ro"
            "-v ${staticConfigFile}:/etc/traefik/traefik.toml:ro"
            "-v ${dynamicConfigFile}:/etc/traefik/dynamic.toml:ro"
          ]
          ++ map (l: "-l ${l}") cfg.extraLabels
          ++ [ cfg.image ]
        );
        ExecStop = "${podman} stop traefik";
        Restart = "on-failure";
        RestartSec = 5;
      };
      Install.WantedBy = [ "default.target" ];
    };
  };
}
