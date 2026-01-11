{ pkgs, ... }:
let
  package = pkgs.junction;
in
{
  home.packages = [ package ];
}
