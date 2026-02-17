{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.cli-proxy-api;

  dataDir = "${config.xdg.dataHome}/cli-proxy-api";
  runtimeConfig = "${dataDir}/config.yaml";

  generatedConfig = pkgs.writeText "cli-proxy-api-config.yaml" (
    builtins.toJSON (
      {
        inherit (cfg) host;
        inherit (cfg) port;
        auth-dir = dataDir;
        api-keys = cfg.apiKeys;
      }
      // cfg.settings
    )
  );

  wrappedPackage =
    pkgs.runCommand "cli-proxy-api-wrapped" { nativeBuildInputs = [ pkgs.makeWrapper ]; }
      ''
        makeWrapper ${lib.getExe cfg.package} $out/bin/cli-proxy-api \
          --add-flags "-config ${runtimeConfig}"
      '';
in
{
  options.services.cli-proxy-api = {
    enable = lib.mkEnableOption "CLIProxyAPI OpenAI-compatible proxy for Claude Max OAuth";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.cli-proxy-api;
      description = "The cli-proxy-api package to use.";
    };

    host = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      description = "Host address to bind to.";
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
      description = "Path to an environment file loaded by the systemd service (e.g. MANAGEMENT_PASSWORD).";
    };

    settings = lib.mkOption {
      type = lib.types.attrs;
      default = { };
      description = "Extra settings merged into config.yaml (as JSON, which is valid YAML).";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ wrappedPackage ];

    home.activation.cliProxyApiConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      mkdir -p "${dataDir}"
      if [ ! -f "${runtimeConfig}" ]; then
        cp "${generatedConfig}" "${runtimeConfig}"
        verboseEcho "cli-proxy-api: seeded config from nix"
      elif ! diff -q "${generatedConfig}" "${runtimeConfig}" >/dev/null 2>&1; then
        warnEcho "cli-proxy-api: ${runtimeConfig} has drifted from nix config"
        warnEcho "  nix: ${generatedConfig}"
        warnEcho "  to reset: cp ${generatedConfig} ${runtimeConfig}"
      fi
    '';

    systemd.user.services.cli-proxy-api = {
      Unit = {
        Description = "CLIProxyAPI proxy server";
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
      Service = {
        Type = "simple";
        ExecStart = "${lib.getExe cfg.package} -config ${runtimeConfig}";
        Restart = "on-failure";
        RestartSec = 5;
      }
      // lib.optionalAttrs (cfg.environmentFile != null) {
        EnvironmentFile = cfg.environmentFile;
      };
    };
  };
}
