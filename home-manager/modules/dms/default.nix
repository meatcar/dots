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
    niri.enableKeybinds = false; # we'll map our own
    niri.enableSpawn = false;
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
          ${qs} -c dms ipc call night enable
          ${qs} -c dms ipc call theme dark
        '';
      };
      lightModeScripts = {
        dms = ''
          ${qs} -c dms ipc call night disable
          ${qs} -c dms ipc call theme light
        '';
      };
    };
}
