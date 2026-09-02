{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.cli-proxy-api;

  piConfigDir = "${config.home.homeDirectory}/.pi/agent/pi-cliproxyapi";
  piConfigFile = "${piConfigDir}/config.json";

  bridgeVersion = "0.9.1";
  cliProxyApiSdkVersion = "7.2.147";

  package = pkgs.buildGoModule {
    pname = "pi-bridge";
    version = bridgeVersion;
    src = inputs.pi-cliproxyapi-bridge;

    postPatch = ''
      go mod edit -require=github.com/router-for-me/CLIProxyAPI/v7@v${cliProxyApiSdkVersion}
      grep -q '^github.com/router-for-me/CLIProxyAPI/v7 ' go.sum
      sed -i '\|^github.com/router-for-me/CLIProxyAPI/v7 |d' go.sum
      printf '%s\n' \
        "github.com/router-for-me/CLIProxyAPI/v7 v${cliProxyApiSdkVersion} h1:ec7Z1iURBXb4+11jlq1gLbxlyyCHGcA1REQpPXbzz0s=" \
        "github.com/router-for-me/CLIProxyAPI/v7 v${cliProxyApiSdkVersion}/go.mod h1:lTHwMAGajc1wKGQiRtDvYbwV0FWsM7sy+N0ZU5/gxJQ=" \
        >> go.sum
    '';

    vendorHash = "sha256-E2K1mC7IiTx7OB8SPtQILSjJOZz8WGJ8kBl9yfdgvRQ=";

    env.CGO_ENABLED = 1;

    buildPhase = ''
      runHook preBuild
      go build -buildmode=c-shared -trimpath -o pi-bridge-v${bridgeVersion}.so .
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      install -Dm755 pi-bridge-v${bridgeVersion}.so \
        "$out/lib/cli-proxy-api/plugins/pi-bridge-v${bridgeVersion}.so"
      runHook postInstall
    '';
  };
in
{
  options.services.cli-proxy-api.piBridge = {
    enable = lib.mkEnableOption "Pi model metadata and quota bridge";

    package = lib.mkOption {
      type = lib.types.package;
      default = package;
      description = "The pi-bridge package to load into CLIProxyAPI.";
    };
  };

  config = lib.mkIf (cfg.enable && cfg.piBridge.enable) {
    assertions = [
      {
        assertion = cfg.package.version == cliProxyApiSdkVersion;
        message = "pi-bridge must be built against CLIProxyAPI ${cfg.package.version}; update its SDK pin and vendor hash";
      }
    ];

    services.cli-proxy-api.settings.plugins = {
      enabled = true;
      dir = "${cfg.piBridge.package}/lib/cli-proxy-api/plugins";
      configs.pi-bridge = {
        enabled = true;
        priority = 3;
        allow_all_api_keys = true;
        show_extra_analytics = cfg.managerPlus.enable;
        store.version = bridgeVersion;
      };
    };

    home.activation.piCliProxyApiBridgeMigration = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      if [ -f ${lib.escapeShellArg piConfigFile} ] \
        && ${lib.getExe pkgs.jq} -e '(.proxy // {}) | has("usageKey")' ${lib.escapeShellArg piConfigFile} >/dev/null
      then
        pi_config_tmp="$(${pkgs.coreutils}/bin/mktemp ${lib.escapeShellArg "${piConfigFile}.XXXXXX"})"
        ${lib.getExe pkgs.jq} 'del(.proxy.usageKey)' ${lib.escapeShellArg piConfigFile} > "$pi_config_tmp"
        chmod --reference=${lib.escapeShellArg piConfigFile} "$pi_config_tmp"
        mv "$pi_config_tmp" ${lib.escapeShellArg piConfigFile}
      fi
      rm -f ${lib.escapeShellArg "${piConfigDir}/usage-key"}
    '';
  };
}
