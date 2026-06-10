{ pkgs, ... }:
{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "audio-record";
      runtimeInputs = with pkgs; [
        pipewire # pw-record
        ffmpeg
        coreutils # date, mktemp, mv, rm
        libnotify # notify-send
      ];
      text = builtins.readFile ./record.sh;
    })
  ];
}
