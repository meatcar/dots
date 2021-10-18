{ config, pkgs, specialArgs, ... }:
let
  src = specialArgs.inputs.nnn;
  nnn = (pkgs.nnn.override {
    withNerdIcons = true;
  }).overrideAttrs (attrs: {
    inherit src;
    # patches = [ "${src}/patches/gitstatus/mainline.diff" ];
  });
in
{
  home.packages = [ nnn ];
}
