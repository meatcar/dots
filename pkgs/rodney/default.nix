{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeBinaryWrapper,
  chromium,
}:
buildGoModule rec {
  pname = "rodney";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "simonw";
    repo = "rodney";
    rev = "v${version}";
    hash = "sha256-/iGsaMfK8zeUkTXwU63mAAb4VpsllG87EH8ycoFZs5k=";
  };

  vendorHash = "sha256-h4U43W3hLoF+p25/jNRaW8okeEzAZQEmKtwB5l4kGW4=";

  nativeBuildInputs = [ makeBinaryWrapper ];

  # Tests require a running Chrome instance
  doCheck = false;

  postInstall = ''
    wrapProgram $out/bin/rodney \
      --set ROD_CHROME_BIN "${chromium}/bin/chromium"
  '';

  meta = {
    description = "CLI tool that drives a persistent headless Chrome instance";
    homepage = "https://github.com/simonw/rodney";
    license = lib.licenses.asl20;
    mainProgram = "rodney";
  };
}
