{
  pkgs,
  lib,
  inputs,
  ...
}:
let
  handyUpstream = inputs.handy.packages.${pkgs.stdenv.hostPlatform.system}.default;

  # Upstream bunDeps hash doesn't match when following our nixpkgs (different bun version).
  # Rebuild with the correct hash until upstream updates.
  fixedBunDeps = pkgs.stdenv.mkDerivation {
    pname = "handy-bun-deps";
    inherit (handyUpstream) version;
    src = inputs.handy;
    nativeBuildInputs = [
      pkgs.bun
      pkgs.cacert
    ];
    dontFixup = true;
    buildPhase = ''
      export HOME=$TMPDIR
      bun install --frozen-lockfile --no-progress
    '';
    installPhase = ''
      mkdir -p $out
      cp -r node_modules $out/
    '';
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = "sha256-+hUANv0w3qnK5d2+4JW3XMazLRDhWCbOxUXQyTGta/0=";
  };

  handy = handyUpstream.overrideAttrs (_old: {
    preBuild = ''
      cp -r ${fixedBunDeps}/node_modules node_modules
      chmod -R +w node_modules
      substituteInPlace node_modules/.bin/{tsc,vite} \
        --replace-fail "/usr/bin/env node" "${lib.getExe pkgs.bun}"
      export HOME=$TMPDIR
      bun run build
    '';
  });

  python = pkgs.python3.withPackages (p: [ p.evdev ]);
  ptt = pkgs.writeShellScriptBin "ptt" ''
    exec ${python}/bin/python3 ${./ptt.py} "$@"
  '';
in
{
  home.packages = [
    handy
    ptt
    pkgs.wtype # Wayland text input (required by Handy on Wayland)
    pkgs.gtk-layer-shell # runtime dep for overlay on Wayland
  ];

  systemd.user.services.handy = {
    Unit = {
      Description = "Handy speech-to-text";
      Wants = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${handy}/bin/handy --start-hidden";
      Restart = "on-failure";
      RestartSec = 3;
      Environment = [
        "ALSA_PLUGIN_DIR=${pkgs.pipewire}/lib/alsa-lib"
      ];
    };
  };
}
