{ stdenv
, lib
, makeWrapper
, sources ? (import ../../nix/sources.nix)
}:
stdenv.mkDerivation rec {
  pname = "wsl-open";
  version = "1.3.1";
  src = sources.wsl-open;
  buildInputs = [ makeWrapper ];
  installPhase = ''
    mkdir -p $out/bin
    makeWrapper ${sources.wsl-open}/wsl-open.sh $out/bin/wsl-open
    mkdir -p $out/usr/share/man/man1
    cp wsl-open.1 $out/usr/share/man/man1
  '';

  meta = with lib; {
    description = "Open files with xdg-open on Bash for Windows in Windows applications";
    license = licenses.mit;
    homepage = https://gitlab.com/4U6U57/wsl-open;
    # maintainers = [ maintainers.meatcar ];
    platforms = platforms.linux;
  };
}
