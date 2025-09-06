{
  config,
  lib,
  nixpkgs-unstable,
  ...
}:
{
  programs.dankMaterialShell = {
    enable = true;
    enableSystemd = true;
    niri.enableKeybinds = false; # we'll map our own
    niri.enableSpawn = false;
    quickshell.package = nixpkgs-unstable.quickshell;
  };
  services.darkman =
    let
      qs = lib.getExe config.programs.dankMaterialShell.quickshell.package;
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
