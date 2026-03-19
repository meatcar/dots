{
  lib,
  pkgs,
  nixpkgs-unstable,
  config,
  ...
}:
let
  # FIXME: https://github.com/ryantm/agenix/issues/300
  xdgRuntimeDir = "/run/user/1000";

  # Wrap age-plugin-1p to reset umask — agenix sets a restrictive umask
  # that breaks `op` CLI session file creation during decryption.
  age-plugin-1p-wrapped = pkgs.writeShellScriptBin "age-plugin-1p" ''
    umask 077
    exec ${pkgs.age-plugin-1p}/bin/age-plugin-1p "$@"
  '';

  age-with-plugins = pkgs.symlinkJoin {
    name = "age-with-plugins";
    paths = [ pkgs.age ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/age \
        --prefix PATH : ${
          lib.makeBinPath [
            age-plugin-1p-wrapped
            nixpkgs-unstable._1password-cli
          ]
        }
    '';
  };
in
{
  imports = [ ../../../secrets/hm-module.nix ];
  age.secretsDir = "${xdgRuntimeDir}/agenix";
  age.package = age-with-plugins;
  age.identityPaths = [
    "${config.home.homeDirectory}/.config/age/age-plugin-1p-identity.txt"
  ];
}
