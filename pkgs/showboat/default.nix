{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "showboat";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "simonw";
    repo = "showboat";
    rev = "v${version}";
    hash = "sha256-yYK6j6j7OgLABHLOSKlzNnm2AWzM2Ig76RJypBsBnkI=";
  };

  vendorHash = "sha256-mGKxBRU5TPgdmiSx0DHEd0Ys8gsVD/YdBfbDdSVpC3U=";

  # Integration tests require python3 and other executables
  doCheck = false;

  meta = {
    description = "Executable demo documents that show and prove an agent's work";
    homepage = "https://github.com/simonw/showboat";
    license = lib.licenses.asl20;
    mainProgram = "showboat";
  };
}
