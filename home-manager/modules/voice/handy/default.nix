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

  # The system /etc/alsa/conf.d/ hardcodes pipewire plugin paths built against the
  # system's alsa-lib (1.2.15). Handy links a different alsa-lib (1.2.14 from
  # home-manager's nixpkgs), so loading those plugins crashes with ENXIO.
  # Fix: patch alsa.conf to load our own conf.d with matching pipewire plugins
  # instead of the system's /etc/alsa/conf.d.
  handyAlsaConf = pkgs.runCommand "handy-alsa-conf" { } ''
    mkdir -p $out/conf.d

    # Pipewire plugin type definitions pointing to our matching version
    cat > $out/conf.d/49-pipewire-modules.conf << 'CONF'
    pcm_type.pipewire {
      libs.native = ${pkgs.pipewire}/lib/alsa-lib/libasound_module_pcm_pipewire.so ;
    }
    ctl_type.pipewire {
      libs.native = ${pkgs.pipewire}/lib/alsa-lib/libasound_module_ctl_pipewire.so ;
    }
    CONF

    # Pipewire named PCM + default device (50-pipewire.conf + 99-pipewire-default.conf)
    # Inlined because /etc is not available in the nix build sandbox.
    cat > $out/conf.d/50-pipewire-default.conf << 'CONF'
    defaults.pipewire.server "pipewire-0"
    defaults.pipewire.node "-1"
    defaults.pipewire.exclusive false
    defaults.pipewire.role ""
    defaults.pipewire.rate 0
    defaults.pipewire.format ""
    defaults.pipewire.channels 0
    defaults.pipewire.period_bytes 0
    defaults.pipewire.buffer_bytes 0

    pcm.pipewire {
      type pipewire
      server {
        @func refer
        name defaults.pipewire.server
      }
      playback_node {
        @func refer
        name defaults.pipewire.node
      }
      capture_node {
        @func refer
        name defaults.pipewire.node
      }
      hint {
        show on
        description "PipeWire Sound Server"
      }
    }
    ctl.pipewire {
      type pipewire
      server {
        @func refer
        name defaults.pipewire.server
      }
    }
    pcm.!default {
      type pipewire
      playback_node "-1"
      capture_node  "-1"
      hint {
        show on
        description "Default ALSA Output (currently PipeWire Media Server)"
      }
    }
    ctl.!default {
      type pipewire
    }
    CONF

    # Patched alsa.conf: replace /etc/alsa/conf.d with our conf.d
    sed 's|"/etc/alsa/conf.d"|"'"$out"'/conf.d"|' \
      ${pkgs.alsa-lib}/share/alsa/alsa.conf > $out/alsa.conf
  '';

  python = pkgs.python3.withPackages (p: [ p.evdev ]);
  ptt = pkgs.writeShellScriptBin "ptt" ''
    exec ${python}/bin/python3 ${./ptt.py} "$@"
  '';
in
{
  home.packages = [
    handy
    ptt
    pkgs.dotool # uinput-based typing (wtype's virtual keyboard sends garbled keycodes on niri)
    pkgs.wtype # Wayland text input (fallback)
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
        "ALSA_CONFIG_PATH=${handyAlsaConf}/alsa.conf"
      ];
    };
  };
}
