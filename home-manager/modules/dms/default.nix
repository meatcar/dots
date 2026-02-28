{
  pkgs,
  lib,
  inputs,
  nixpkgs-unstable,
  ...
}:
let
  dms = lib.getExe inputs.dank-material-shell.packages.${pkgs.stdenv.hostPlatform.system}.dms-shell;
  pathPrefix = "PATH=${lib.makeBinPath [ nixpkgs-unstable.quickshell ]}:$PATH";
in
{
  programs.dank-material-shell = {
    enable = true;
    systemd.enable = true;
    quickshell.package = nixpkgs-unstable.quickshell;
    dgop.package = nixpkgs-unstable.dgop;
  };
  services.darkman = {
    darkModeScripts = {
      dms = ''
        export ${pathPrefix}
        ${dms} ipc night enable
        ${dms} ipc theme dark
      '';
    };
    lightModeScripts = {
      dms = ''
        export ${pathPrefix}
        ${dms} ipc night disable
        ${dms} ipc theme light
      '';
    };
  };
}
