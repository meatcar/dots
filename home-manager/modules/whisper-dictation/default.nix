{
  pkgs,
  inputs,
  ...
}:
let
  whisper-dictation-base = inputs.whisper-dictation.packages.${pkgs.stdenv.hostPlatform.system}.default;
  whisper-dictation = whisper-dictation-base.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [
      ./device-config.patch
      ./disable-notifications.patch
    ];
  });
  gi-typelib-path = pkgs.lib.makeSearchPath "lib/girepository-1.0" (
    with pkgs;
    [
      graphene
      pango.out
      gdk-pixbuf
      harfbuzz
    ]
  );
in
{
  home.packages = [
    whisper-dictation
    pkgs.ydotool
  ];

  xdg.configFile."whisper-dictation/config.yaml".text = ''
    hotkey:
      key: semicolon
      modifiers:
        - super

    device:
      name: keyd virtual keyboard

    ui:
      notifications: false

    whisper:
      model: base
      language: en
  '';

  systemd.user.services.ydotoold = {
    Unit = {
      Description = "ydotool daemon";
      Wants = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.ydotool}/bin/ydotoold --socket-path=%t/.ydotool_socket --socket-perm=0600";
      Restart = "on-failure";
      RestartSec = 3;
    };
  };

  systemd.user.services.whisper-dictation = {
    Unit = {
      Description = "Whisper Dictation daemon";
      Wants = [ "graphical-session.target" ];
      After = [
        "graphical-session.target"
        "ydotoold.service"
      ];
      Requires = [ "ydotoold.service" ];
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
    Service = {
      Type = "simple";
      Environment = [
        "YDOTOOL_SOCKET=%t/.ydotool_socket"
        "GI_TYPELIB_PATH=${gi-typelib-path}"
        "PATH=${pkgs.lib.makeBinPath [ pkgs.procps ]}"
      ];
      ExecStart = "${whisper-dictation}/bin/whisper-dictation -v";
      Restart = "on-failure";
      RestartSec = 3;
    };
  };
}
