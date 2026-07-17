{ inputs, ... }:
{
  # Also required for rootless home-manager quadlets: provides the systemd
  # generator. Rootless additionally needs users with linger + subuid/subgid.
  imports = [ inputs.quadlet-nix.nixosModules.quadlet ];

  virtualisation.quadlet.enable = true;
}
