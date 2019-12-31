{ lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  sources = mkOption {
    description = "The sources, as provided by Niv";
    type = types.attrs;
  };
}
// (import ./themes.nix { inherit lib; })
// (import ./mail.nix { inherit lib; })
