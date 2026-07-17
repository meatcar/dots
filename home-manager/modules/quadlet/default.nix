{ inputs, ... }:
{
  # Rootless podman quadlets. The NixOS side (modules/quadlet) provides the
  # systemd generator; without it these units are inert.
  imports = [ inputs.quadlet-nix.homeManagerModules.quadlet ];
}
