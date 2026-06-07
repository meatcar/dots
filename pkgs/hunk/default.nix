{
  lib,
  stdenv,
  stdenvNoCC,
  fetchurl,
  autoPatchelfHook,
  gcc-unwrapped,
  zlib,
  openssl,
}:
stdenvNoCC.mkDerivation rec {
  pname = "hunk";
  version = "0.14.1";

  src = fetchurl {
    url = "https://github.com/modem-dev/hunk/releases/download/v${version}/hunkdiff-linux-x64.tar.gz";
    hash = "sha256-enmhID6L4tr8+KDgvi8XvJhMsFC+GVoHEKh3YkSqiP4=";
  };

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];
  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    gcc-unwrapped.lib
    zlib
    openssl
  ];

  sourceRoot = "hunkdiff-linux-x64";

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 hunk $out/bin/hunk
    cp -r skills $out/
    runHook postInstall
  '';

  meta = {
    description = "Terminal diff viewer for agentic changesets";
    homepage = "https://github.com/modem-dev/hunk";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = "hunk";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
