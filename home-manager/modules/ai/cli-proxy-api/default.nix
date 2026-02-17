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
      // lib.optionalAttrs (cfg.managementKey != "") {
        remote-management = {
          secret-key = cfg.managementKey;
        };
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

    managementKey = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Secret key for the management API. Empty disables management routes.";
    };

    settings = lib.mkOption {
      type = lib.types.attrs;
      default = { };
      description = "Extra settings merged into config.yaml (as JSON, which is valid YAML).";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ wrappedPackage ];

    systemd.user.services.cli-proxy-api = {
      Unit = {
        Description = "CLIProxyAPI proxy server";
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
      Service = {
        Type = "simple";
        ExecStartPre = "${pkgs.coreutils}/bin/install -Dm644 ${generatedConfig} ${runtimeConfig}";
        ExecStart = "${lib.getExe cfg.package} -config ${runtimeConfig}";
        Restart = "on-failure";
        RestartSec = 5;
      };
    };
  };
}
