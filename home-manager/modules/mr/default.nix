{
  pkgs,
  ...
}:
let
  mr = pkgs.writeShellScriptBin "mr" ''
    # A wrapper around mr to automatically parallelize it.
    MR_MAX_PROCS=''${MR_MAX_PROCS:-5}
    NPROCS=$(${
      # rendered text is unchanged on Linux; darwin has no /proc
      if pkgs.stdenv.isLinux then "grep -c ^processor /proc/cpuinfo" else "sysctl -n hw.ncpu"
    })
    if [ "$NPROCS" -gt "$MR_MAX_PROCS" ]; then
      NPROCS=$MR_MAX_PROCS
    fi
    ${pkgs.mr}/bin/mr --jobs "$NPROCS" "$@"
  '';
in
{
  home.packages = [
    mr
    pkgs.perlPackages.PodPerldoc
  ];
}
