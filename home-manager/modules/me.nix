# Declarations for the `me.*` option namespace, shared by all hosts.
{ config, lib, ... }:
{
  options.me.PRJ_ROOT = lib.mkOption {
    type = lib.types.str;
    default = "${config.home.homeDirectory}/git/hub/meatcar/dots/dots-default";
    description = "Absolute filesystem path to the working copy of this flake (PRJ_ROOT per prj-spec; used by mkOutOfStoreSymlink targets).";
  };
}
