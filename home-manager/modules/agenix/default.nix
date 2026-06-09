{
  lib,
  pkgs,
  config,
  ...
}:
let
  identityFile = "${config.xdg.configHome}/age/id_ed25519";
  cfg = config.me.age;
in
{
  imports = [ ../../../secrets/hm-module.nix ];

  options.me.age.opPrivateKeyRef = lib.mkOption {
    type = lib.types.nullOr lib.types.str;
    default = null;
    description = "1Password secret reference (op://) for the age private key.";
  };

  config = {
    # FIXME: https://github.com/ryantm/agenix/issues/300
    age.secretsDir = "/run/user/1000/agenix";
    age.identityPaths = [ identityFile ];

    # Keep the oneshot "active (exited)" so that downstream Requires=
    # (e.g. vdirsyncer) don't re-trigger decryption every 5 minutes.
    systemd.user.services.agenix.Service.RemainAfterExit = true;

    home.activation.generateAgeIdentity = lib.hm.dag.entryBefore [ "agenixNewGeneration" ] (
      if cfg.opPrivateKeyRef != null then
        ''
          if [ ! -s "${identityFile}" ]; then
            run mkdir -p "$(dirname "${identityFile}")"
            ${pkgs._1password-cli}/bin/op read ${lib.escapeShellArg cfg.opPrivateKeyRef} > "${identityFile}"
            chmod 600 "${identityFile}"
            run ${pkgs.openssh}/bin/ssh-keygen -y -f "${identityFile}" > "${identityFile}.pub"
            echo "Age identity restored from 1Password."
          fi
        ''
      else
        ''
          if [ ! -s "${identityFile}" ]; then
            run mkdir -p "$(dirname "${identityFile}")"
            run ${pkgs.openssh}/bin/ssh-keygen -t ed25519 -f "${identityFile}" -N "" -C "age-identity"
            echo "New age identity generated. Add this public key to secrets/secrets.nix, then run: agenix -r"
            cat "${identityFile}.pub"
          fi
        ''
    );
  };
}
