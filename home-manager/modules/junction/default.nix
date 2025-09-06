{ pkgs, lib, ... }:
let
  package = pkgs.junction;
in
{
  home.packages = [ package ];
}
