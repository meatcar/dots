{
  stdenv,
  lib,
  fetchzip,
  makeWrapper,
}:
stdenv.mkDerivation rec {
  pname = "wsl-open";
  version = "2.2.1";
  src = fetchzip {
    url = "https://gitlab.com/4U6U57/wsl-open/-/archive/v${version}/wsl-open-v${version}.tar.gz";
    sha256 = "sha256-amqkDXdgIqGjRZMkltwco0UAI++G0RY/MxLXwtlxogE=";
  };
  buildInputs = [makeWrapper];
  installPhase = ''
    mkdir -p $out/bin
    chmod +x ${src}/wsl-open.sh
    makeWrapper ${src}/wsl-open.sh $out/bin/wsl-open
    mkdir -p $out/usr/share/man/man1
    cp wsl-open.1 $out/usr/share/man/man1
  '';

  meta = with lib; {
    description = "Open files with xdg-open on Bash for Windows in Windows applications";
    license = licenses.mit;
    homepage = https://gitlab.com/4U6U57/wsl-open;
    maintainers = [maintainers.meatcar];
    platforms = platforms.linux;
  };
}
