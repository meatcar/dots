# Patched dms-shell: re-runs DisplayConfigState.checkIncludeStatus() and
# validateProfiles() once CompositorService finishes its async compositor
# detection, fixing the false "First Time Setup" warning and empty output
# profiles on a cold boot.  See display-config-state.patch.
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
