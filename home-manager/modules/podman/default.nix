{ pkgs, ... }:
{
  home.packages = with pkgs; [
    lazydocker
    podman-tui
  ];
}
