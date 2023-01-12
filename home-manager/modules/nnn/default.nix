{ config, pkgs, ... }:
{
  programs.nnn = {
    enable = true;
    package =
      (pkgs.nnn.override {
        withNerdIcons = true;
      }).overrideAttrs (attrs: {
        patches = [ "${attrs.src}/patches/gitstatus/mainline.diff" ];
      });
  };
}
