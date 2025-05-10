# source: https://github.com/czerwonk/nixfiles/blob/68f89b511169ac7dd39e1e8d4f96b0b5d3499cbf/pkgs/all-ways-egpu/default.nix
{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation rec {
  pname = "all-ways-egpu";
  version = "0.52.1";

  src = fetchFromGitHub {
    owner = "ewagner12";
    repo = pname;
    rev = "97870b57cdae39e9fb88c58108aa13ef7df40a35";
    hash = "sha256-sSGFn72RyF7Er6pMukDKiJbZV7tqSKr+FHRgGWUf0Gs=";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp all-ways-egpu $out/bin/.
    chmod +x $out/bin/all-ways-egpu

    mkdir -p $out/lib/systemd/system
    cp systemd/* $out/lib/systemd/system/.
  '';

  meta = with lib; {
    description = "Configures eGPU as primary under Linux Wayland desktops";
    homepage = "https://github.com/ewagner12/all-ways-egpu";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = "all-ways-egpu";
  };
}
