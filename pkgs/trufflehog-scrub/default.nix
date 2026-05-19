{
  lib,
  stdenvNoCC,
  python3,
}:
stdenvNoCC.mkDerivation {
  pname = "trufflehog-scrub";
  version = "0.2.0";

  src = ./.;

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 trufflehog-scrub.py "$out/bin/trufflehog-scrub"
    substituteInPlace "$out/bin/trufflehog-scrub" \
      --replace-fail "#!/usr/bin/env python3" "#!${python3}/bin/python3"
    runHook postInstall
  '';

  meta = {
    description = "Consume trufflehog --json output and optionally redact found secrets in place";
    mainProgram = "trufflehog-scrub";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
}
