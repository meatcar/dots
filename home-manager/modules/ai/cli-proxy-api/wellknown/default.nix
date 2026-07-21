{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.cli-proxy-api;
  sidecarCfg = cfg.quotaSidecar;

  usageKeyDir = "${config.home.homeDirectory}/.pi/agent/pi-cliproxyapi";
  usageKeyFile = "${usageKeyDir}/usage-key";

  app = pkgs.runCommand "pi-cliproxyapi-wellknown-app" { } ''
    mkdir -p "$out"
    cp -r ${inputs.pi-cliproxyapi-wellknown}/src "$out/src"
  '';

  entrypoint = pkgs.writeShellScriptBin "pi-cliproxyapi-wellknown-entrypoint" ''
    set -eu
    : "''${MANAGEMENT_PASSWORD:?MANAGEMENT_PASSWORD is required}"
    export MANAGEMENT_API_KEY="$MANAGEMENT_PASSWORD"
    IFS= read -r PI_PLUGIN_USAGE_KEY < ${usageKeyFile}
    export PI_PLUGIN_USAGE_KEY
    exec ${pkgs.python3}/bin/python3 ${app}/src/server.py
  '';

  image = pkgs.dockerTools.buildLayeredImage {
    name = "localhost/pi-cliproxyapi-wellknown";
    tag = "latest";
    contents = [
      app
      entrypoint
      pkgs.cacert
      pkgs.python3
    ];
    config = {
      Entrypoint = [ "${entrypoint}/bin/pi-cliproxyapi-wellknown-entrypoint" ];
      Env = [
        "PYTHONDONTWRITEBYTECODE=1"
        "PYTHONUNBUFFERED=1"
        "SSL_CERT_FILE=/etc/ssl/certs/ca-bundle.crt"
      ];
    };
  };
in
{
  options.services.cli-proxy-api.quotaSidecar = {
    enable = lib.mkEnableOption "Pi CLIProxyAPI model metadata and quota sidecar";

    port = lib.mkOption {
      type = lib.types.port;
      default = 3458;
      description = "Internal port for the Pi CLIProxyAPI sidecar.";
    };

    publicBaseUrl = lib.mkOption {
      type = lib.types.str;
      default = "http://cli-proxy-api.localhost/v1";
      description = "CLIProxyAPI URL used by Pi and advertised in model discovery.";
    };
  };

  config = lib.mkIf (cfg.enable && sidecarCfg.enable) {
    assertions = [
      {
        assertion = cfg.apiKeys != [ ];
        message = "services.cli-proxy-api.quotaSidecar requires at least one CLIProxyAPI API key";
      }
      {
        assertion = cfg.environmentFile != null;
        message = "services.cli-proxy-api.quotaSidecar requires environmentFile with MANAGEMENT_PASSWORD";
      }
      {
        assertion = config.services.traefik.enable;
        message = "services.cli-proxy-api.quotaSidecar requires Traefik for same-origin routing";
      }
    ];

    home.activation.piCliProxyApiUsageKey = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      install -d -m 0700 ${lib.escapeShellArg usageKeyDir}
      if [ ! -s ${lib.escapeShellArg usageKeyFile} ]; then
        umask 077
        ${pkgs.openssl}/bin/openssl rand -hex 32 > ${lib.escapeShellArg usageKeyFile}
      fi
      chmod 0600 ${lib.escapeShellArg usageKeyFile}
    '';

    services.traefik.dynamicConfigOptions.http = {
      routers.pi-cliproxyapi-wellknown = {
        rule = "Host(`cli-proxy-api.localhost`) && (Path(`/.well-known/pi`) || PathPrefix(`/api/usage`))";
        priority = 100;
        service = "pi-cliproxyapi-wellknown";
      };
      services.pi-cliproxyapi-wellknown.loadBalancer.servers = [
        { url = "http://pi-cliproxyapi-wellknown:${toString sidecarCfg.port}"; }
      ];
    };

    virtualisation.quadlet =
      let
        inherit (config.virtualisation.quadlet) images networks;
      in
      {
        images.pi-cliproxyapi-wellknown = {
          # Home Manager restarts changed image units; pull the dependent
          # container back up after an input update replaces this image.
          unitConfig.Wants = [ "pi-cliproxyapi-wellknown.service" ];
          imageConfig = {
            image = "docker-archive:${image}";
            tag = "localhost/pi-cliproxyapi-wellknown:latest";
          };
        };

        containers.pi-cliproxyapi-wellknown = {
          unitConfig = {
            After = [
              "agenix.service"
              "cli-proxy-api.service"
            ];
            Requires = [
              "agenix.service"
              "cli-proxy-api.service"
            ];
          };
          serviceConfig = {
            Restart = "on-failure";
            RestartSec = 5;
          };
          containerConfig = {
            image = images.pi-cliproxyapi-wellknown.ref;
            name = "pi-cliproxyapi-wellknown";
            networks = [ networks.ai.ref ];
            environments = {
              HOST = "0.0.0.0";
              PORT = toString sidecarCfg.port;
              UPSTREAM_MODELS_URL = "http://cli-proxy-api:${toString cfg.port}/v1/models";
              UPSTREAM_TOKEN = builtins.head cfg.apiKeys;
              PI_PUBLIC_BASE_URL = sidecarCfg.publicBaseUrl;
              CACHE_TTL_MS = "60000";
              MANAGEMENT_API_URL = "http://cli-proxy-api:${toString cfg.port}/v0/management";
            };
            environmentFiles = [ cfg.environmentFile ];
            volumes = [ "${usageKeyFile}:${usageKeyFile}:ro" ];
            dropCapabilities = [ "all" ];
            noNewPrivileges = true;
            readOnly = true;
          };
        };
      };
  };
}
