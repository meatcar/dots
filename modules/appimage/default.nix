{ config, nixpkgs-unstable, ... }:
{
  programs.appimage.enable = true;
  programs.appimage.binfmt = true;
  # unstable: stable's dwarfs dep isn't on cache.nixos.org (hydra gap)
  programs.appimage.package = nixpkgs-unstable.appimage-run.override {
    extraPkgs = _: [
      config.programs._1password-gui.package
    ];
  };
  environment.systemPackages = [ nixpkgs-unstable.gearlever ];
}
