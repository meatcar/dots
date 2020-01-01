{ config, lib, ... }:
{
  options = {
    niv = lib.mkOption {
      description = "The sources, as provided by Niv";
      type = lib.types.attrs;
    };
  };
  config = { niv = import ../nix/sources.nix; };
}
