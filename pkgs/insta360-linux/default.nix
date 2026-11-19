{
  lib,
  stdenv,
  fetchFromGitHub,
  nodejs_24,
  pnpm,
  fetchPnpmDeps,
  pnpmConfigHook,
  makeWrapper,
  v4l-utils,
  mpv,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "insta360-linux";
  version = "0.1.0-unstable-2026-03-02";

  src = fetchFromGitHub {
    owner = "EdenCoder";
    repo = "insta360-linux";
    rev = "98ab785db53d203579f97d430372f39a85fcfdee";
    hash = "sha256-jw1ra/1n+28SZc2r/i1XWdKLJ47HTqnbAwLrR86rNOk=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    inherit pnpm;
    fetcherVersion = 4;
    hash = "sha256-ZsI+b4uXjvYNkCi9WRnGyAAateoqEzxuYll3kzdiKiM=";
  };

  nativeBuildInputs = [
    nodejs_24
    pnpm
    pnpmConfigHook
    makeWrapper
  ];

  # NOTE: src/*.ts already start with a shebang; the tsup banner adds a second one that node rejects.
  postPatch = ''
    substituteInPlace tsup.config.ts \
      --replace-fail 'js: "#!/usr/bin/env node",' ""
  '';

  # NOTE: upstream compiles xu_helper beside dist/ on first use; the store is read-only, so build it here.
  buildPhase = ''
    runHook preBuild
    pnpm run build
    node ${./extract-xu-helper.mjs} src/v4l2.ts > xu_helper.c
    $CC -O2 -o dist/xu_helper xu_helper.c
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    pnpm prune --prod --ignore-scripts
    mkdir -p $out/lib/insta360-linux
    cp -r dist node_modules package.json $out/lib/insta360-linux/
    makeWrapper ${lib.getExe nodejs_24} $out/bin/insta360 \
      --add-flags $out/lib/insta360-linux/dist/cli.js \
      --prefix PATH : ${lib.makeBinPath [ v4l-utils ]}
    makeWrapper ${lib.getExe nodejs_24} $out/bin/insta360-tui \
      --add-flags $out/lib/insta360-linux/dist/tui.js \
      --prefix PATH : ${
        lib.makeBinPath [
          v4l-utils
          mpv
        ]
      }
    runHook postInstall
  '';

  meta = {
    description = "Controller for Insta360 Link webcams: AI tracking, PTZ, modes, and image controls";
    homepage = "https://github.com/EdenCoder/insta360-linux";
    license = lib.licenses.mit;
    mainProgram = "insta360";
    platforms = lib.platforms.linux;
  };
})
