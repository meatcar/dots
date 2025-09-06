{ pkgs, config, ... }:
{
  programs.appimage.enable = true;
  programs.appimage.binfmt = true;
  programs.appimage.package = pkgs.appimage-run.override {
    extraPkgs = _: [
      config.programs._1password-gui.package
    ];
  };
  environment.systemPackages = [ pkgs.gearlever ];
}
