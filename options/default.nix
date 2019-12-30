{ lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  imports = [
    ./themes.nix
    ./mail.nix
  ];
  sources = mkOption {
    description = "The sources, as provided by Niv";
    type = types.attrs;
  };
}
