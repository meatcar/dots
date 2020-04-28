# TODO: don't use builtins.fetchGit, @infinisil says its not allowed in nixpkgs
# TODO: @infinisil says add a meta.platforms attribute for nixpkgs

# NOTE: I never got this to build. I got stuck with ly requiring a command to
# be run between cloning and checking out submodules.
#
# Keeping this around to be tackled later, and for other's reference.
#
# The maintainer seems unwilling to change the current structure
# (see https://github.com/cylgom/ly/issues/147), so next steps perhaps would
# be to:
#
# - explore packaging each dependency, and pulling them in to skip the submodule step. That would explode the number of packages to maintain.
# - try to convince the maintainer to imp
{ stdenv, lib, fetchgit, linux-pam, xorg }:

let
  argoat = builtins.fetchGit {
    url = "https://github.com/cylgom/argoat.git";
    rev = "36c41f09ecc2a10c9acf35e4194e08b6fa10cf45";
  };
  testoasterror = builtins.fetchGit {
    url = "https://github.com/cylgom/testoasterror.git";
    rev = "71620b47872b5535f87c908883576d73153a6911";
  };
  configator = builtins.fetchGit {
    url = "https://github.com/cylgom/configator.git";
    rev = "c3e1ef175418ccb5b0981ae64ec6f5ae4a60fbaf";
  };
  ctypes = builtins.fetchGit {
    url = "https://github.com/cylgom/ctypes.git";
    rev = "5dd979d3644ab0c85ca14e72b61e6d3d238d432b";
  };
  dragonfail = builtins.fetchGit {
    url = "https://github.com/cylgom/dragonfail.git";
    rev = "6b40d1f8b7f6dda9746e688666af623dfbcceb94";
  };
  termbox_next = builtins.fetchGit {
    url = "https://github.com/cylgom/termbox_next.git";
    rev = "d3568927865c15d033d4096cb446d5a3628e2398";
  };
in
stdenv.mkDerivation rec {
  pname = "ly";
  version = "2019-10-04";

  src = builtins.fetchGit {
    url = "https://github.com/cylgom/ly.git";
    rev = "d839a9229640bb17a59b6cfc5ba3c9119ea56a7d";
  };

  buildInputs = [ linux-pam xorg.libxcb ];
  makeFlags = [ "FLAGS=-Wno-error" ];

  preBuild = ''
    rm -r sub/*
    cp -r --no-preserve=mode ${argoat} sub/argoat
    ls -al sub/argoat/sub
    rm -r sub/argoat/sub/*
    cp -r --no-preserve=mode ${testoasterror} sub/argoat/sub/testasterror
    cp -r --no-preserve=mode ${configator} sub/configator
    cp -r --no-preserve=mode ${ctypes} sub/ctypes
    cp -r --no-preserve=mode ${dragonfail} sub/dragonfail
    cp -r --no-preserve=mode ${termbox_next} sub/termbox_next
  '';

  installPhase = ''
    mkdir tmp
    make DESTDIR=tmp install

    mkdir -p $out/etc $out/bin
    cp -r tmp/etc/ly $out/etc/
    cp tmp/usr/bin/ly $out/bin/
    mkdir -p $out/lib/systemd/system
    substitute tmp/usr/lib/systemd/system/ly.service \
           $out/lib/systemd/system/ly.service \
           --replace /usr/bin/ly $out/bin/ly
  '';

  meta = with lib; {
    description = "TUI display manager";
    license = licenses.wtfpl;
    homepage = https://github.com/cylgom/ly;
    maintainers = [ maintainers.spacekookie maintainers.meatcar ];
    platforms = platforms.linux;
  };
}
