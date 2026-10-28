{
  config,
  pkgs,
  ...
}:
let
  fix-appimage-magic = pkgs.writeShellApplication {
    name = "fix-appimage-magic";
    runtimeInputs = [ pkgs.coreutils ];
    text = builtins.readFile ./fix-appimage-magic.sh;
  };
in
{
  programs.appimage.enable = true;
  programs.appimage.binfmt = true;
  programs.appimage.package = pkgs.appimage-run.override {
    extraPkgs = _: [
      config.programs._1password-gui.package
    ];
  };
  # NOTE: Gear Lever is a Flatpak (home-manager/modules/flatpak); nixpkgs lags upstream.

  systemd.user.services.fix-appimage-magic = {
    description = "Restore AppImage magic bytes zeroed by self-updaters";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${fix-appimage-magic}/bin/fix-appimage-magic %h/AppImages";
    };
    # sweep at login for updates missed while logged out
    wantedBy = [ "default.target" ];
  };

  systemd.user.paths.fix-appimage-magic = {
    description = "Watch ~/AppImages for self-updater file swaps";
    pathConfig = {
      PathChanged = "%h/AppImages";
      PathModified = "%h/AppImages";
    };
    wantedBy = [ "paths.target" ];
  };
}
