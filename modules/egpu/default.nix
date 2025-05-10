{
  pkgs,
  ...
}:
let
  get-wlr-drm-devices = pkgs.writeShellScriptBin "get-wlr-drm-devices" (
    builtins.readFile ./get-wlr-drm-devices.sh
  );
in
{
  # Don't forget to authorize and enroll the egpu with boltctl
  services.hardware.bolt.enable = true;
  systemd.services.reload-amd-gpu = {
    enable = true;
    description = "Reload AMD GPU Driver";
    wantedBy = [ "multi-user.target" ];
    path = [
      pkgs.kmod
      pkgs.pciutils
    ];
    serviceConfig.ExecStart =
      let
        reloadAmdGpu = pkgs.writeShellScript "reloadAmdGpu" ''
          echo $PATH
          # boltd turns on the eGPU, but the Navi 10 AMD card errors out with
          # [drm:amdgpu_discovery_init [amdgpu]] *ERROR* invalid ip discovery binary signature
          # Reloading the driver seems to fix the problem.
          if lsmod | grep -q amdgpu && lspci | grep VGA | grep 'Navi 10'; then
            rmmod amdgpu
            modprobe amdgpu
          fi
        '';
      in
      "${reloadAmdGpu}";
  };
  environment.systemPackages = [ get-wlr-drm-devices ];
  programs.sway.extraSessionCommands = ''
    export WLR_DRM_DEVICES=$(${get-wlr-drm-devices}/bin/get-wlr-drm-devices)
  '';
}
