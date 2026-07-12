{
  pkgs,
  lib,
  ...
}:
{
  config = lib.mkIf pkgs.stdenv.isLinux {
    home.packages = [
      (pkgs.writers.writePython3Bin "audio-record" {
        flakeIgnore = [
          "E501" # ruff-format line length
          "W503"
        ];
        makeWrapperArgs = [
          "--prefix"
          "PATH"
          ":"
          (lib.makeBinPath [
            pkgs.pipewire # pw-record
            pkgs.ffmpeg
            pkgs.libnotify # notify-send
          ])
        ];
      } (builtins.readFile ./audio_record.py))
    ];
  };
}
