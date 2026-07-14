# Patches two upstream DisplayConfigState races (display-config-state.patch):
# - profile validation runs before async compositor detection finishes,
#   leaving a false "First Time Setup" and empty profiles on cold boot
# - matchedProfile is only computed at startup and behind auto-select, so
#   with auto-select off the `dms ipc` [matched] tag goes permanently stale
{ pkgs, inputs }:
let
  orig = inputs.dank-material-shell.packages.${pkgs.stdenv.hostPlatform.system}.dms-shell;
in
pkgs.runCommand "dms-shell-patched" { inherit (orig) meta; } ''
  cp -r ${orig} $out
  chmod -R u+w $out
  patch -p1 -d $out < ${./display-config-state.patch}
  # The bin/dms wrapper hardcodes the original store path for both the
  # .dms-wrapped binary and the -c QML directory.  Repoint them to $out
  # so quickshell loads the patched QML.
  substituteInPlace $out/bin/dms \
    --replace-fail '${orig}' "$out"
''
