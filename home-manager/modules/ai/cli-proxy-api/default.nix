{
  config,
  lib,
  pkgs,
  llm-agents,
  ...
}:
let
  cfg = config.services.cli-proxy-api;

  dataDir = "${config.xdg.dataHome}/cli-proxy-api";
  authDir = "${dataDir}/auth";
  runtimeConfig = "${dataDir}/config.yaml";

  generatedConfig = pkgs.writeText "cli-proxy-api-config.yaml" (
    builtins.toJSON (
      {
        # bind all interfaces inside the container netns; only the published
        # port on cfg.host is reachable from outside it
        host = "0.0.0.0";
        inherit (cfg) port;
        auth-dir = authDir;
        api-keys = cfg.apiKeys;
        # config is mounted read-only; remote management could otherwise
        # rewrite it at runtime
        remote-management.allow-remote = false;
      }
      // cfg.settings
    )
  );

  # auth dir is mounted at the same path inside the container, so this config
  # is valid both in the container and for the host CLI
  image = pkgs.dockerTools.buildLayeredImage {
    name = "localhost/cli-proxy-api";
    tag = "latest";
    contents = [
      cfg.package
      pkgs.cacert
    ];
    config = {
      Entrypoint = [
        "/bin/cli-proxy-api"
        "-config"
        runtimeConfig
      ];
      Env = [ "SSL_CERT_FILE=/etc/ssl/certs/ca-bundle.crt" ];
    };
  };

  wrappedPackage =
    pkgs.runCommand "cli-proxy-api-wrapped" { nativeBuildInputs = [ pkgs.makeWrapper ]; }
      ''
        makeWrapper ${lib.getExe cfg.package} $out/bin/cli-proxy-api \
          --add-flags "-config ${generatedConfig}"
      '';
in
{
  imports = [
    ../../quadlet
    ../../traefik
    ./wellknown
  ];

  options.services.cli-proxy-api = {
    enable = lib.mkEnableOption "CLIProxyAPI OpenAI-compatible proxy for Claude Max OAuth";

    package = lib.mkOption {
      type = lib.types.package;
      default = llm-agents.cli-proxy-api;
      description = "The cli-proxy-api package to use.";
    };

    host = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      description = "Host address the container port is published on.";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 8317;
      description = "Port to listen on.";
    };

    apiKeys = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ "local" ];
      description = "API keys for authenticating clients to the proxy.";
    };

    environmentFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "Path to an environment file loaded by the container (e.g. MANAGEMENT_PASSWORD).";
    };

    settings = lib.mkOption {
      type = lib.types.attrs;
      default = { };
      description = "Extra settings merged into config.yaml (as JSON, which is valid YAML).";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ wrappedPackage ];

    home.activation.cliProxyApiAuthDir = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      mkdir -p "${authDir}"
      # migrate pre-split token files (auth-dir used to be the data dir root)
      for f in "${dataDir}"/*.json; do
        if [ -e "$f" ]; then
          mv "$f" "${authDir}/"
          verboseEcho "cli-proxy-api: migrated $f to auth/"
        fi
      done
    '';

    # one URL everywhere: hosts resolve *.localhost to loopback (resolved),
    # containers on `ai` resolve the alias to traefik
    services.traefik = lib.mkIf config.services.traefik.enable {
      networks = [ config.virtualisation.quadlet.networks.ai.ref ];
      networkAliases = [ "cli-proxy-api.localhost" ];
      dynamicConfigOptions.http = {
        routers.cli-proxy-api = {
          rule = "Host(`cli-proxy-api.localhost`)";
          service = "cli-proxy-api";
        };
        services.cli-proxy-api.loadBalancer.servers = [
          { url = "http://cli-proxy-api:${toString cfg.port}"; }
        ];
      };
    };

    virtualisation.quadlet =
      let
        inherit (config.virtualisation.quadlet) images networks;
      in
      {
        networks.ai = { }; # aardvark-dns resolves container names on it

        images.cli-proxy-api.imageConfig = {
          image = "docker-archive:${image}";
          tag = "localhost/cli-proxy-api:latest";
        };

        containers.cli-proxy-api = {
          unitConfig = lib.optionalAttrs (cfg.environmentFile != null) {
            After = [ "agenix.service" ];
            Requires = [ "agenix.service" ];
          };
          serviceConfig = {
            Restart = "on-failure";
            RestartSec = 5;
          };
          containerConfig = {
            image = images.cli-proxy-api.ref;
            name = "cli-proxy-api"; # DNS name; default would be systemd-cli-proxy-api
            networks = [ networks.ai.ref ];
            publishPorts = [ "${cfg.host}:${toString cfg.port}:${toString cfg.port}" ];
            volumes = [
              "${generatedConfig}:${runtimeConfig}:ro"
              "${authDir}:${authDir}"
            ];
            environmentFiles = lib.optional (cfg.environmentFile != null) cfg.environmentFile;
            dropCapabilities = [ "all" ];
            noNewPrivileges = true;
            readOnly = true; # tmpfs /tmp via quadlet's default ReadOnlyTmpfs
            # management.html isn't embedded; fetched at runtime into <config dir>/static
            tmpfses = [ "${dataDir}/static" ];
          };
        };
      };
  };
}
