{
  pkgs,
  config,
  inputs,
  nixpkgs-unstable,
  ...
}:
let
  # Handy follows nixpkgs-unstable, so its alsa-lib differs from the NixOS
  # system's (nixos-stable). The system's /etc/alsa/conf.d/ pipewire plugins
  # link stable's alsa-lib, causing dlopen failures. Fix: use unstable's
  # pipewire and alsa-lib so the plugin matches handy's linked alsa-lib.
  pw = nixpkgs-unstable.pipewire;

  # NixOS generates 49-pipewire-modules.conf to map pcm_type/ctl_type to
  # explicit .so paths. Without it ALSA can't find the pipewire plugin.
  pipewireModulesConf = pkgs.writeText "49-pipewire-modules.conf" ''
    pcm_type.pipewire {
      libs.native = ${pw}/lib/alsa-lib/libasound_module_pcm_pipewire.so ;
    }
    ctl_type.pipewire {
      libs.native = ${pw}/lib/alsa-lib/libasound_module_ctl_pipewire.so ;
    }
  '';

  handyAlsaConf = pkgs.runCommand "handy-alsa-conf" { } ''
    mkdir -p $out/conf.d
    cp ${pw}/share/alsa/alsa.conf.d/* $out/conf.d/
    cp ${pipewireModulesConf} $out/conf.d/49-pipewire-modules.conf

    sed 's|"/etc/alsa/conf.d"|"'"$out"'/conf.d"|' \
      ${nixpkgs-unstable.alsa-lib}/share/alsa/alsa.conf > $out/alsa.conf
  '';

  python = pkgs.python3.withPackages (p: [ p.evdev ]);
  ptt = pkgs.writeShellScriptBin "ptt" ''
    exec ${python}/bin/python3 ${./ptt.py} "$@"
  '';
in
{
  imports = [ inputs.handy.homeManagerModules.default ];

  services.handy.enable = true;

  # Upstream module doesn't support --start-hidden or ALSA workaround
  systemd.user.services.handy.Service = {
    ExecStart = pkgs.lib.mkForce "${config.services.handy.package}/bin/handy --start-hidden";
    Environment = [
      "ALSA_CONFIG_PATH=${handyAlsaConf}/alsa.conf"
    ];
  };

  home.packages = [
    config.services.handy.package
    ptt
    pkgs.dotool # uinput-based typing (wtype's virtual keyboard sends garbled keycodes on niri)
    pkgs.wtype # Wayland text input (fallback)
    pkgs.gtk-layer-shell # runtime dep for overlay on Wayland
  ];
}
