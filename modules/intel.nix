{ config, pkgs, lib, ... }:
{
  boot = {
    initrd.kernelModules = [ "i915" ];
    kernelParams = [
      "i915.fastboot=1"
      "i915.enable_fbc=1"
      "i915.enable_psr=1"
      "i915.enable_guc=2"
    ];
  };

  hardware.cpu.intel.updateMicrocode = true;

  nixpkgs.config = {
    packageOverrides = pkgs: {
      vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
    };
  };

  hardware.opengl.extraPackages = builtins.attrValues {
    inherit (pkgs) vaapiIntel vaapiVdpau libvdpau-va-gl intel-media-driver;
  };
}
