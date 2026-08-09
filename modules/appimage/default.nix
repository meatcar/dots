{
  config,
  pkgs,
  nixpkgs-unstable,
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
  # unstable: stable's dwarfs dep isn't on cache.nixos.org (hydra gap)
  programs.appimage.package = nixpkgs-unstable.appimage-run.override {
    extraPkgs = _: [
      config.programs._1password-gui.package
    ];
  };
  environment.systemPackages = [ nixpkgs-unstable.gearlever ];

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
