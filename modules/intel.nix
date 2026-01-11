{
  pkgs,
  ...
}:
{
  hardware.cpu.intel.updateMicrocode = true;

  nixpkgs.config = {
    packageOverrides = pkgs: {
      vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
    };
  };

  hardware.graphics.extraPackages = [
    pkgs.vaapiIntel
    pkgs.vaapiVdpau
    pkgs.libvdpau-va-gl
    pkgs.intel-media-driver
  ];
}
