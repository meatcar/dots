# FIXME: switch to buildGoModule once nixpkgs has go_1_26
# https://nixpk.gs/pr-tracker.html?pr=490463
{
  lib,
  fetchurl,
  stdenvNoCC,
}:
let
  version = "6.8.18";
in
stdenvNoCC.mkDerivation {
  pname = "cli-proxy-api";
  inherit version;

  src = fetchurl {
    url = "https://github.com/router-for-me/CLIProxyAPI/releases/download/v${version}/CLIProxyAPI_${version}_linux_amd64.tar.gz";
    hash = "sha256-zzYEMbphablHpi4yUkmlaPtz3I/TGRojgxJriryKxmQ=";
  };

  sourceRoot = ".";

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 cli-proxy-api $out/bin/cli-proxy-api
    runHook postInstall
  '';

  meta = {
    description = "OpenAI-compatible API proxy for Claude Max OAuth";
    homepage = "https://github.com/router-for-me/CLIProxyAPI";
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    mainProgram = "cli-proxy-api";
  };
}
