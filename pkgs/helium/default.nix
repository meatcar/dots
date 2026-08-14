{
  appimageTools,
  fetchurl,
  lib,
  makeWrapper,
  pkgs,
  stdenvNoCC,
  commandLineArgs ? [ ],
}:

let
  pname = "helium";
  version = "0.14.6.1";

  src = fetchurl {
    url = "https://github.com/imputnet/helium-linux/releases/download/${version}/helium-${version}-x86_64.AppImage";
    hash = "sha256-qdM1Qysx5OOBwzr6A6tyPIfZcHxn2YkIPedGelvbk7I=";
  };

  # Extract the vendor AppImage into the Nix store without patching its payload.
  # appimageTools.wrapType2 is deliberately not used: it launches through
  # buildFHSEnv/bubblewrap, whose no_new_privs setting prevents 1Password's
  # setgid BrowserSupport helper from entering secure-execution mode.
  contents = appimageTools.extract {
    inherit pname version src;
  };

  appimageDependencies =
    appimageTools.defaultFhsEnvArgs.targetPkgs pkgs ++ appimageTools.defaultFhsEnvArgs.multiPkgs pkgs;

  libraryPath = lib.concatStringsSep ":" [
    "${contents}/usr/lib"
    "${contents}/usr/lib64"
    (lib.makeLibraryPath appimageDependencies)
    (lib.makeSearchPathOutput "lib" "lib64" appimageDependencies)
  ];
in
stdenvNoCC.mkDerivation {
  inherit pname version;

  dontUnpack = true;
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin" "$out/share/applications" "$out/share/icons/hicolor/256x256/apps"

    makeWrapper ${contents}/opt/helium/helium "$out/bin/helium" \
      --prefix LD_LIBRARY_PATH : ${lib.escapeShellArg libraryPath} \
      --set-default CHROME_VERSION_EXTRA appimage-nix-store \
      ${lib.concatMapStringsSep " " (arg: "--add-flags ${lib.escapeShellArg arg}") commandLineArgs}

    install -m 0444 ${contents}/helium.desktop "$out/share/applications/helium.desktop"
    install -m 0444 ${contents}/helium.png "$out/share/icons/hicolor/256x256/apps/helium.png"

    runHook postInstall
  '';

  passthru = {
    inherit contents src;
  };

  meta = {
    description = "Private, fast, and honest web browser";
    homepage = "https://helium.computer";
    license = lib.licenses.gpl3Only;
    mainProgram = "helium";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
