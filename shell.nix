let
  sources = import ./nix/sources.nix;
  nixPath = import ./nix-path.nix;
in
{ pkgs ? import sources.nixpkgs {} }:
pkgs.stdenv.mkDerivation {
  name = "dots";
  NIX_PATH = builtins.concatStringsSep ":" nixPath;
  buildInputs = [
    pkgs.stow
    pkgs.niv
  ];
}
