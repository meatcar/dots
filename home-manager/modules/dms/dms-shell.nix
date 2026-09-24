# UPSTREAM(dank-material-shell): local bug fixes; submit upstream.
#
# Patches upstream display-profile races and khal startup recovery:
# - profile validation runs before async compositor detection finishes,
#   leaving a false "First Time Setup" and empty profiles on cold boot
# - matchedProfile is only computed at startup and behind auto-select, so
#   with auto-select off the `dms ipc` [matched] tag goes permanently stale
# - khal availability stays false after a transient startup failure
{
  pkgs,
  inputs,
  quickshell,
}:
let
  orig = inputs.dank-material-shell.packages.${pkgs.stdenv.hostPlatform.system}.dms-shell;
in
pkgs.runCommand "dms-shell-patched"
  {
    inherit (orig) meta;
    nativeBuildInputs = [
      pkgs.python3
      quickshell
    ];
  }
  ''
    cp -r ${orig} $out
    chmod -R u+w $out
    patch -p1 -d $out < ${./display-config-state.patch}
    patch -p1 -d $out < ${./calendar-khal-retry.patch}
    python3 ${./test-calendar-khal-retry.py} $out/share/quickshell/dms/Services/CalendarKhalBackend.qml
    # The bin/dms wrapper hardcodes the original store path for both the
    # .dms-wrapped binary and the -c QML directory.  Repoint them to $out
    # so quickshell loads the patched QML.
    substituteInPlace $out/bin/dms \
      --replace-fail '${orig}' "$out"
  ''
