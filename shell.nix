let
  sources = import ./nix/sources.nix;
  nixPath = import ./nix-path.nix;
in
{ pkgs ? import sources.nixpkgs { } }:
pkgs.stdenv.mkDerivation {
  name = "dots";
  NIX_PATH = builtins.concatStringsSep ":" nixPath;
  buildInputs = [
    pkgs.stow
    pkgs.niv
    (pkgs.writeShellScriptBin "nixos-rebuild-pretty" ''
      # prettier than nixos-rebuild switch
      sudo -E sh -c "nix build --no-link -f '<nixpkgs/nixos>' config.system.build.toplevel && nixos-rebuild $@"
    '')
    (pkgs.writeShellScriptBin "hm" ''
      home-manager -I ${builtins.concatStringsSep " -I " nixPath} "$@"
    '')
  ];
}
