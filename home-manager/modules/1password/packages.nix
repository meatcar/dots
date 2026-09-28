{ lib, pkgs, ... }:
{
  options.programs = {
    _1password.package = lib.mkPackageOption pkgs "1Password CLI" {
      default = [ "_1password-cli" ];
    };
    _1password-gui.package = lib.mkPackageOption pkgs "1Password GUI" {
      default = [ "_1password-gui" ];
    };
  };
}
