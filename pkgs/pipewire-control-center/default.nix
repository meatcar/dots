{
  lib,
  python3Packages,
  fetchFromGitHub,
  wrapGAppsHook4,
  gobject-introspection,
  gtk4,
  libadwaita,
  pipewire,
  wireplumber,
  pulseaudio,
  xdg-utils,
}:
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "pipewire-control-center";
  version = "0.6.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "knightinfected";
    repo = "PipeWireController";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1r3aHVhirJW8HJZ/Y25sNT/v/sFt0Nr0o8149FPntWo=";
  };

  # NOTE: SPA backend probe only knows FHS paths; point it at the daemon's tree.
  postPatch = ''
    substituteInPlace pwctl/backend/backends.py \
      --replace-fail "SPA_DIRS = [Path('/usr/lib/spa-0.2')," \
                     "SPA_DIRS = [Path('${pipewire}/lib/spa-0.2'), Path('/usr/lib/spa-0.2'),"
  '';

  build-system = [ python3Packages.hatchling ];

  nativeBuildInputs = [
    wrapGAppsHook4
    gobject-introspection
  ];

  buildInputs = [
    gtk4
    libadwaita
  ];

  dependencies = with python3Packages; [
    pygobject3
    pycairo
    numpy
    soundfile
  ];

  dontWrapGApps = true;
  preFixup = ''
    makeWrapperArgs+=(
      "''${gappsWrapperArgs[@]}"
      --prefix PATH : ${
        lib.makeBinPath [
          pipewire
          wireplumber
          pulseaudio
          xdg-utils
        ]
      }
    )
  '';

  postInstall = ''
    install -Dm644 io.github.knightinfected.PipeWireControlCenter.desktop \
      -t $out/share/applications
  '';

  nativeCheckInputs = [ python3Packages.pytestCheckHook ];
  pythonImportsCheck = [ "pwctl.backend.eqcurve" ];

  meta = {
    description = "GTK4/libadwaita control center for PipeWire";
    homepage = "https://github.com/knightinfected/PipeWireController";
    changelog = "https://github.com/knightinfected/PipeWireController/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.gpl3Plus;
    mainProgram = "pipewire-control-center";
    platforms = lib.platforms.linux;
  };
})
