{
  config,
  inputs,
  lib,
  ...
}:
{
  # Rootless podman quadlets. The NixOS side (modules/quadlet) provides the
  # systemd generator; without it these units are inert.
  imports = [ inputs.quadlet-nix.homeManagerModules.quadlet ];

  # quadlet-nix keeps only a stub at ~/.config/systemd/user/<unit>.service
  # ([Install] + a config hash); the real [Service] section (ExecStart=podman
  # run ...) is injected as a drop-in that resolves through the pivot symlink
  # ~/.config/quadlet-nix/out -> $XDG_RUNTIME_DIR/systemd/generator/. Because
  # ~/.config/systemd/user sorts ahead of the generator dir in UnitPath, that
  # drop-in is the *only* source of ExecStart.
  #
  # Upstream creates the pivot in an activation step ordered merely `before
  # reloadSystemd`, which puts it *after* linkGeneration has already written
  # the drop-in symlinks. Any user manager that loads units in that window sees
  # stub-only units, refuses them ("Service has no ExecStart="), and drops
  # their default.target start jobs. Nothing retries: at login HM's own
  # reloadSystemd bails with "User systemd daemon not running. Skipping
  # reload.", so the whole rootless stack stays dead for the session.
  #
  # Create the pivot before linkGeneration so a drop-in is never written
  # without a resolvable target. Impermanence also persists .config/quadlet-nix
  # so the pivot exists before the session starts at all.
  home.activation.quadletNix = lib.mkForce (
    lib.hm.dag.entryBetween [ "linkGeneration" ] [ "writeBoundary" ] ''
      run mkdir -p ${lib.escapeShellArg "${config.xdg.configHome}/quadlet-nix"}
      run ln -sf "''${XDG_RUNTIME_DIR:-/run/user/$UID}/systemd/generator/" \
        ${lib.escapeShellArg "${config.xdg.configHome}/quadlet-nix/out"}
    ''
  );
}
