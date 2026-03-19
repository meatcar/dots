{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:
rustPlatform.buildRustPackage rec {
  pname = "weave";
  version = "0.2.6";

  src = fetchFromGitHub {
    owner = "ataraxy-labs";
    repo = "weave";
    rev = "v${version}";
    hash = "sha256-XlSjdyKG/EQMFX3Ac/8yf7mHlD3Hb19MNMvRqmefg0A=";
  };

  cargoHash = "sha256-NtoRGvF8FWcQkrmNbeut1cU66ob8iNVpl3WJ35avDBk=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  cargoBuildFlags = [
    "--package"
    "weave-cli"
    "--package"
    "weave-driver"
  ];

  meta = {
    description = "Entity-level semantic merge driver using tree-sitter";
    homepage = "https://github.com/ataraxy-labs/weave";
    license = lib.licenses.mit;
    mainProgram = "weave";
  };
}
