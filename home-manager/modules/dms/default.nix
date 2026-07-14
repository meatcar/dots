# DankMaterialShell (dms): bar, launcher, notifications, lock screen, theming.
#
# This file declares what we want from dms. Every negotiation with the rest of
# the world lives in a sibling file, one concern per file. Files headed with
# UPSTREAM(project) exist only because something is missing upstream; each
# header says what to send there, and landing it deletes the file.
{
  pkgs,
  inputs,
  nixpkgs-unstable,
  ...
}:
{
  imports = [
    ./lifecycle.nix
    ./output-profiles.nix
    ./idle.nix
    ./tray.nix
    ./darkman-bridge.nix
  ];

  programs.dank-material-shell = {
    enable = true;
    package = import ./dms-shell.nix { inherit pkgs inputs; };
    systemd.enable = true;
    quickshell.package = nixpkgs-unstable.quickshell;
    dgop.package = nixpkgs-unstable.dgop;
  };

  home.packages = [
    pkgs.kdePackages.kimageformats
    pkgs.adw-gtk3
  ];
}
