{
  lib,
  stdenv,
  stdenvNoCC,
  fetchurl,
  autoPatchelfHook,
  makeBinaryWrapper,
  curl,
  libxml2_13,
  sqlite,
}:
let
  version = "0.27.0";

  sources = {
    x86_64-linux = {
      url = "https://github.com/steipete/CodexBar/releases/download/v${version}/CodexBarCLI-v${version}-linux-x86_64.tar.gz";
      hash = "sha256-mWP0wJ03t4P5dvT1/sswY1idGVKRG8BE8nhBeY714FU=";
    };
    aarch64-linux = {
      url = "https://github.com/steipete/CodexBar/releases/download/v${version}/CodexBarCLI-v${version}-linux-aarch64.tar.gz";
      hash = "sha256-6nq0X5PWGW3QWPMdYZrxhkrJHzEbQ+Ln/IXEyetkEYc=";
    };
    x86_64-darwin = {
      url = "https://github.com/steipete/CodexBar/releases/download/v${version}/CodexBarCLI-v${version}-macos-x86_64.tar.gz";
      hash = "sha256-PgK84HrDje2/VXbrJtJ03zEcDp1fVR2HNb82iD4itOE=";
    };
    aarch64-darwin = {
      url = "https://github.com/steipete/CodexBar/releases/download/v${version}/CodexBarCLI-v${version}-macos-arm64.tar.gz";
      hash = "sha256-v3k5ZL3Mxvnas+suQOEa47JWbfAx6FiwZf1ujqRBbcI=";
    };
  };

  source =
    sources.${stdenv.hostPlatform.system}
      or (throw "codexbar: unsupported platform ${stdenv.hostPlatform.system}");
in
stdenvNoCC.mkDerivation {
  pname = "codexbar";
  inherit version;

  src = fetchurl source;

  sourceRoot = ".";

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    autoPatchelfHook
    makeBinaryWrapper
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    (lib.getLib stdenv.cc.cc)
    curl
    libxml2_13
    sqlite
  ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 CodexBarCLI $out/libexec/CodexBarCLI
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    # Swift Foundation on Linux crashes resolving named time zones because
    # /usr/share/zoneinfo is hard-coded but missing on NixOS. Force TZ to
    # the magic localtime form so glibc reads /etc/localtime directly and
    # Foundation never attempts the named lookup.
    makeBinaryWrapper $out/libexec/CodexBarCLI $out/bin/CodexBarCLI \
      --set-default TZ ':/etc/localtime'
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/bin
    ln -s ../libexec/CodexBarCLI $out/bin/CodexBarCLI
  ''
  + ''
    ln -s CodexBarCLI $out/bin/codexbar
    runHook postInstall
  '';

  meta = {
    description = "CLI companion for CodexBar — usage stats for OpenAI Codex, Claude Code, and other AI coding providers";
    homepage = "https://github.com/steipete/CodexBar";
    license = lib.licenses.mit;
    platforms = lib.attrNames sources;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    mainProgram = "codexbar";
  };
}
