{
  lib,
  pkgs,
  config,
  ...
}:
let
  # Absolute path: systemd ExecStart uses a compile-time search path, not $PATH.
  op = "/run/wrappers/bin/op";

  # Poll until the op daemon is accepting connections.
  opDaemonReady = pkgs.writeShellScript "op-daemon-ready" ''
    for _ in $(seq 1 30); do
      ${op} account list >/dev/null 2>&1 && exit 0
      sleep 0.5
    done
    echo "op-daemon: timed out waiting for readiness" >&2
    exit 1
  '';

  # Ensure op is authenticated. Meant to be `source`d.
  opEnsureAuth = pkgs.writeShellScript "op-ensure-auth" ''
    ${op} whoami >/dev/null 2>&1 || ${op} signin >/dev/null 2>&1
  '';

  # Wrap rage to work around two NixOS 1Password issues:
  # - agenix sets umask 0377 which breaks op's session creation
  # - op auth is scoped per-process-tree, so signin must happen here
  age-with-plugins = pkgs.writeShellApplication {
    name = "rage";
    runtimeInputs = [ pkgs.age-plugin-1p ];
    text = ''
      umask 077
      # shellcheck source=/dev/null
      source ${opEnsureAuth}
      exec ${lib.getExe pkgs.rage} "$@"
    '';
  };

  cfg = config.me.age;
  identityFile = "${config.xdg.configHome}/age/age-plugin-1p-identity.txt";
in
{
  imports = [ ../../../secrets/hm-module.nix ];

  options.me.age.opPrivateKeyRef = lib.mkOption {
    type = lib.types.str;
    description = "1Password item reference for the age private key (e.g. op://Vault/Item/private key).";
  };

  config = {
    # FIXME: https://github.com/ryantm/agenix/issues/300
    age.secretsDir = "/run/user/1000/agenix";
    age.package = age-with-plugins;
    age.identityPaths = [ identityFile ];

    # No Install section: started only when agenix pulls it in via Requires.
    systemd.user.services.op-daemon = {
      Unit.Description = "1Password CLI daemon";
      Service = {
        Type = "simple";
        ExecStart = "${op} daemon";
        ExecStartPost = toString opDaemonReady;
      };
    };

    systemd.user.services.agenix.Unit = {
      After = [ "op-daemon.service" ];
      Wants = [ "op-daemon.service" ];
    };
    # Keep the oneshot "active (exited)" so that downstream Requires=
    # (e.g. vdirsyncer) don't re-trigger decryption every 5 minutes.
    systemd.user.services.agenix.Service.RemainAfterExit = true;

    home.activation.generateAgeIdentity = lib.hm.dag.entryBefore [ "agenixNewGeneration" ] ''
      if [ ! -s "${identityFile}" ]; then
        source ${opEnsureAuth}
        run mkdir -p "$(dirname "${identityFile}")"
        run ${lib.getExe pkgs.age-plugin-1p} --generate "${cfg.opPrivateKeyRef}" --output "${identityFile}"
      fi
    '';
  };
}
