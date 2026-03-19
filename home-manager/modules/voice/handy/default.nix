{
  pkgs,
  config,
  inputs,
  ...
}:
let
  # Handy is built against nixpkgs-unstable. Our pipewire is coming from
  # nixos-stable, so there's a mismatch in alsa-lib versions, causing alsa-lib
  # crashes with ENXIO.
  # Fix: use nixpkgs pipewire's own shipped conf files from our nixpkgs,
  # and redirect alsa.conf to load them instead of /etc/alsa/conf.d/.
  handyAlsaConf = pkgs.runCommand "handy-alsa-conf" { } ''
    mkdir -p $out/conf.d
    cp ${pkgs.pipewire}/share/alsa/alsa.conf.d/* $out/conf.d/

    sed 's|"/etc/alsa/conf.d"|"'"$out"'/conf.d"|' \
      ${pkgs.alsa-lib}/share/alsa/alsa.conf > $out/alsa.conf
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
    ptt
    pkgs.dotool # uinput-based typing (wtype's virtual keyboard sends garbled keycodes on niri)
    pkgs.wtype # Wayland text input (fallback)
    pkgs.gtk-layer-shell # runtime dep for overlay on Wayland
  ];
}
