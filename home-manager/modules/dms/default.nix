{
  nixpkgs-unstable,
  ...
}:
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
