{ config, pkgs, lib, ... }:
let
  mr = pkgs.writeScriptBin "mr" ''
    #!/bin/sh
    MR_MAX_PROCS=''${MR_MAX_PROCS:-5}
    NPROCS=$(grep -c ^processor /proc/cpuinfo)
    if [ "$NPROCS" -gt "$MR_MAX_PROCS" ]; then
      NPROCS=$MR_MAX_PROCS
    fi
    ${pkgs.mr}/bin/mr --jobs "$NPROCS"
  '';
in
{
  home.packages = [
    mr
    pkgs.perlPackages.PodPerldoc
  ];
}
