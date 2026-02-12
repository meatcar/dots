{
  pkgs,
  inputs,
  ...
}:
let
  handy = inputs.handy.packages.${pkgs.stdenv.hostPlatform.system}.default;
  python = pkgs.python3.withPackages (p: [ p.evdev ]);
  handy-ptt = pkgs.writeShellScriptBin "handy-ptt" ''
    exec ${python}/bin/python3 ${./handy-ptt.py} "$@"
  '';
in
{
  home.packages = [
    handy
    handy-ptt
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
      ExecStart = "${handy}/bin/handy";
      Restart = "on-failure";
      RestartSec = 3;
      Environment = [
        "ALSA_PLUGIN_DIR=${pkgs.pipewire}/lib/alsa-lib"
      ];
    };
  };
}
