{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.cli-proxy-api;
  managerCfg = cfg.managerPlus;

  version = "1.12.8";
  release =
    {
      x86_64-linux = inputs.cpa-manager-plus-amd64;
      aarch64-linux = inputs.cpa-manager-plus-arm64;
    }
    .${pkgs.stdenv.hostPlatform.system}
      or (throw "CPA Manager Plus does not support ${pkgs.stdenv.hostPlatform.system}");

  package = pkgs.stdenvNoCC.mkDerivation {
    pname = "cpa-manager-plus";
    inherit version;

    src = release;
    dontUnpack = true;

    installPhase = ''
      runHook preInstall
      install -Dm755 ${release}/cpa-manager-plus "$out/bin/cpa-manager-plus"
      runHook postInstall
    '';

    meta = {
      description = "CLIProxyAPI management and observability dashboard";
      homepage = "https://github.com/seakee/CPA-Manager-Plus";
      license = lib.licenses.mit;
      mainProgram = "cpa-manager-plus";
      platforms = [
        "x86_64-linux"
        "aarch64-linux"
      ];
    };
  };

  dataDir = "${config.xdg.dataHome}/cpa-manager-plus";
  adminKeyFile = "${dataDir}/admin-key";

  initializeData = pkgs.writeShellScript "cpa-manager-plus-initialize" ''
    set -eu
    ${pkgs.coreutils}/bin/install -d -m 0700 ${lib.escapeShellArg dataDir}
    if [ ! -s ${lib.escapeShellArg adminKeyFile} ]; then
      umask 077
      admin_key_tmp=${lib.escapeShellArg "${adminKeyFile}.tmp"}
      printf 'cpamp_' > "$admin_key_tmp"
      ${lib.getExe pkgs.openssl} rand -hex 32 >> "$admin_key_tmp"
      ${pkgs.coreutils}/bin/mv "$admin_key_tmp" ${lib.escapeShellArg adminKeyFile}
    fi
    ${pkgs.coreutils}/bin/chmod 0600 ${lib.escapeShellArg adminKeyFile}
  '';

  entrypoint = pkgs.writeShellScriptBin "cpa-manager-plus-entrypoint" ''
    set -eu
    : "''${MANAGEMENT_PASSWORD:?MANAGEMENT_PASSWORD is required}"
    management_password="$MANAGEMENT_PASSWORD"
    exec ${pkgs.coreutils}/bin/env -i \
      HTTP_ADDR=0.0.0.0:${toString managerCfg.port} \
      USAGE_DATA_DIR=/data \
      USAGE_DB_PATH=/data/usage.sqlite \
      CPA_MANAGER_DATA_KEY_PATH=/data/data.key \
      CPA_MANAGER_ADMIN_KEY_FILE=/data/admin-key \
      CPA_UPSTREAM_URL=http://cli-proxy-api:${toString cfg.port} \
      CPA_MANAGEMENT_KEY="$management_password" \
      USAGE_COLLECTOR_MODE=auto \
      USAGE_BATCH_SIZE=100 \
      USAGE_POLL_INTERVAL_MS=500 \
      USAGE_QUERY_LIMIT=50000 \
      SSL_CERT_FILE=/etc/ssl/certs/ca-bundle.crt \
      TZDIR=/share/zoneinfo \
      ${lib.getExe managerCfg.package}
  '';

  image = pkgs.dockerTools.buildLayeredImage {
    name = "localhost/cpa-manager-plus";
    tag = "latest";
    contents = [
      entrypoint
      managerCfg.package
      pkgs.cacert
      pkgs.tzdata
    ];
    config.Entrypoint = [ "${entrypoint}/bin/cpa-manager-plus-entrypoint" ];
  };
in
{
  options.services.cli-proxy-api.managerPlus = {
    enable = lib.mkEnableOption "CPA Manager Plus full manager";

    package = lib.mkOption {
      type = lib.types.package;
      default = package;
      description = "The CPA Manager Plus package to run.";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 18317;
      description = "Internal port for CPA Manager Plus.";
    };
  };

  config = lib.mkIf (cfg.enable && managerCfg.enable) {
    assertions = [
      {
        assertion = cfg.environmentFile != null;
        message = "services.cli-proxy-api.managerPlus requires environmentFile with MANAGEMENT_PASSWORD";
      }
      {
        assertion = config.services.traefik.enable;
        message = "services.cli-proxy-api.managerPlus requires Traefik";
      }
    ];

    systemd.user.services = {
      cpa-manager-plus.Service.ExecStartPre = initializeData;
      cli-proxy-api.Service.ExecStartPre = lib.mkIf cfg.piBridge.enable initializeData;
    };

    services.traefik.dynamicConfigOptions.http = {
      routers.cpa-manager-plus = {
        rule = "Host(`cpa-manager-plus.localhost`)";
        service = "cpa-manager-plus";
      };
      services.cpa-manager-plus.loadBalancer.servers = [
        { url = "http://cpa-manager-plus:${toString managerCfg.port}"; }
      ];
    };

    virtualisation.quadlet =
      let
        inherit (config.virtualisation.quadlet) images networks;
      in
      {
        images.cpa-manager-plus.imageConfig = {
          image = "docker-archive:${image}";
          tag = "localhost/cpa-manager-plus:latest";
        };

        containers.cli-proxy-api.containerConfig.volumes = lib.optional cfg.piBridge.enable "${adminKeyFile}:/CLIProxyAPI/cpam-admin-key:ro";

        containers.cpa-manager-plus = {
          unitConfig = {
            After = [
              "agenix.service"
              "cli-proxy-api.service"
            ];
            Wants = [
              "agenix.service"
              "cli-proxy-api.service"
            ];
          };
          serviceConfig = {
            Restart = "on-failure";
            RestartSec = 5;
          };
          containerConfig = {
            image = images.cpa-manager-plus.ref;
            name = "cpa-manager-plus";
            networks = [ networks.ai.ref ];
            environmentFiles = [ cfg.environmentFile ];
            volumes = [ "${dataDir}:/data" ];
            dropCapabilities = [ "all" ];
            noNewPrivileges = true;
            readOnly = true;
            tmpfses = [ "/tmp" ];
          };
        };
      };
  };
}
