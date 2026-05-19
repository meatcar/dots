{
  lib,
  pkgs,
  config,
  ...
}:
let
  identityFile = "${config.xdg.configHome}/age/id_ed25519";
in
{
  imports = [ ../../../secrets/hm-module.nix ];

  config = {
    # FIXME: https://github.com/ryantm/agenix/issues/300
    age.secretsDir = "/run/user/1000/agenix";
    age.identityPaths = [ identityFile ];

    # Keep the oneshot "active (exited)" so that downstream Requires=
    # (e.g. vdirsyncer) don't re-trigger decryption every 5 minutes.
    systemd.user.services.agenix.Service.RemainAfterExit = true;

    # Auto-generate the key on a new machine. Note: the public key must then
    # be added to secrets/secrets.nix and secrets re-encrypted with: agenix -r
    home.activation.generateAgeIdentity = lib.hm.dag.entryBefore [ "agenixNewGeneration" ] ''
      if [ ! -s "${identityFile}" ]; then
        run mkdir -p "$(dirname "${identityFile}")"
        run ${pkgs.openssh}/bin/ssh-keygen -t ed25519 -f "${identityFile}" -N "" -C "age-identity"
        echo "New age identity generated. Add this public key to secrets/secrets.nix, then run: agenix -r"
        cat "${identityFile}.pub"
      fi
    '';
  };
}
