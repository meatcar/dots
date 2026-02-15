{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.cli-proxy-api;

  configDir = "${config.xdg.configHome}/cli-proxy-api";

  configContent = builtins.toJSON (
    {
      inherit (cfg) host;
      inherit (cfg) port;
      auth-dir = "${config.xdg.dataHome}/cli-proxy-api";
      api-keys = cfg.apiKeys;
    }
    // cfg.settings
  );

  wrappedPackage =
    pkgs.runCommand "cli-proxy-api-wrapped" { nativeBuildInputs = [ pkgs.makeWrapper ]; }
      ''
        makeWrapper ${lib.getExe cfg.package} $out/bin/cli-proxy-api \
          --add-flags "-config ${configDir}/config.yaml"
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

    settings = lib.mkOption {
      type = lib.types.attrs;
      default = { };
      description = "Extra settings merged into config.yaml (as JSON, which is valid YAML).";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ wrappedPackage ];

    xdg.configFile."cli-proxy-api/config.yaml".text = configContent;

    systemd.user.services.cli-proxy-api = {
      Unit = {
        Description = "CLIProxyAPI proxy server";
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
      Service = {
        Type = "simple";
        ExecStart = "${lib.getExe cfg.package} -config ${configDir}/config.yaml";
        Restart = "on-failure";
        RestartSec = 5;
      };
    };
  };
}
