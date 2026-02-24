{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "qe-mac-apid";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "quickemu-project";
    repo = "qe_mac_apid";
    rev = "v${version}";
    hash = "sha256-nWuOWlCSgThDG2Nk+6qgYn7PNtB5TAN+DFPTWljaUHQ=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-kt3uuiHUdOAy9SXxQBJClGJKxoq9BrXO3NoSbMU2s/Y=";

  nativeBuildInputs = [ rustPlatform.bindgenHook ];

  meta = {
    description = "Modify OpenCore QCOW2 images for Apple ID authentication in macOS VMs";
    homepage = "https://github.com/quickemu-project/qe_mac_apid";
    license = lib.licenses.gpl3Only;
    mainProgram = "qe_mac_apid";
  };
}
