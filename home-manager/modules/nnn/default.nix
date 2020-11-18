{ config, pkgs, ... }:
let
  nnn = pkgs.nnn.overrideAttrs
    (attrs: {
      makeFlags = attrs.makeFlags ++ [ "O_NERD=1" ];
    });
in
{
  home.packages = [ nnn ];
}
