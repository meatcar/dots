{
  lib,
  stdenv,
  fetchFromGitHub,
  nodejs_24,
  pnpm,
  fetchPnpmDeps,
  pnpmConfigHook,
  makeWrapper,
  git,
  gh,
  glab,
  which,
  versionCheckHook,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "forgemap";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "TitusKirch";
    repo = "forgemap";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Ana8AGKCz9xExQPvqaPWGDeYxJ1Qt/3E73hcdK7eSHg=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    inherit pnpm;
    fetcherVersion = 4;
    hash = "sha256-hY6bnMjHzUrQvFIHbF3/5vIpCy9PIu5fQKon2gTuzCo=";
  };

  nativeBuildInputs = [
    nodejs_24
    pnpm
    pnpmConfigHook
    makeWrapper
  ];
  HUSKY = "0";

  nativeCheckInputs = [
    git
    which
  ];

  buildPhase = ''
    runHook preBuild
    pnpm run build
    runHook postBuild
  '';

  doCheck = true;
  checkPhase = ''
    runHook preCheck
    pnpm exec vitest run
    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall
    pnpm prune --prod --ignore-scripts
    mkdir -p $out/lib/forgemap
    cp -r dist node_modules package.json $out/lib/forgemap/
    makeWrapper ${lib.getExe nodejs_24} $out/bin/forgemap \
      --add-flags $out/lib/forgemap/dist/bin/forgemap.mjs \
      --prefix PATH : ${
        lib.makeBinPath [
          git
          gh
          glab
          which
        ]
      }
    runHook postInstall
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Clone and organize repositories by forge and owner";
    homepage = "https://github.com/TitusKirch/forgemap";
    license = lib.licenses.mit;
    mainProgram = "forgemap";
    platforms = lib.platforms.unix;
  };
})
