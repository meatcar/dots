{
  config,
  lib,
  nixpkgs-unstable,
  ...
}:
{
  programs.dank-material-shell = {
    enable = true;
    systemd.enable = true;
    # niri.enableKeybinds = false; # we'll map our own
    # niri.enableSpawn = false;
    quickshell.package = nixpkgs-unstable.quickshell;
    dgop.package = nixpkgs-unstable.dgop;
  };
  services.darkman =
    let
      qs = lib.getExe config.programs.dank-material-shell.quickshell.package;
    in
    {
      darkModeScripts = {
        dms = ''
          dms ipc call night enable
          dms ipc call theme dark
        '';
      };
      lightModeScripts = {
        dms = ''
          dms ipc call night disable
          dms ipc call theme light
        '';
      };
    };
}
