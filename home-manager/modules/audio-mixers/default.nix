{ pkgs, ... }:
{
  home.packages = with pkgs; [
    pwvucontrol # per-app routing, device meters, card profiles
    qpwgraph # graph/patchbay view of nodes and links
  ];
}
