{ nixpkgs-unstable, pkgs, ... }:
{
  home.packages = with nixpkgs-unstable; [
    lazydocker
    podman-tui
  ];

  # not using home-manager
  # services.podman.enable = true;
  xdg.configFile."containers/policy.json".source = "${pkgs.skopeo.src}/default-policy.json";
}
