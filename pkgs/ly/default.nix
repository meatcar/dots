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
{
  stdenv,
  lib,
  fetchgit,
  runCommand,
  path,
  linux-pam,
  libxcb,
}:
stdenv.mkDerivation rec {
  pname = "ly";
  version = "0.5.3";

  src =
    let
      # locally modify `nix-prefetch-git` to recursively use upstream’s .github as .gitmodules…
      fetchgitMod =
        args:
        (fetchgit args).overrideAttrs (_oldAttrs: {
          fetcher = runCommand "nix-prefetch-git-mod" { } ''
            cp ${path}/pkgs/build-support/fetchgit/nix-prefetch-git $out
            sed '/^init_submodules\(\)/a [ -e .gitmodules ] || cp .github .gitmodules || true' -i $out
            chmod 755 $out
          '';
        });
    in
    fetchgitMod {
      url = "https://github.com/cylgom/ly.git";
      rev = "v${version}";
      sha256 = "sha256-3pxT0TrJsdOJlZMY9z2oM6MzUssW4N7dc6SItda7aP4=";
    };

  buildInputs = [
    linux-pam
    libxcb
  ];

  preConfigure = ''
    sed '/^FLAGS=/a FLAGS+= -Wno-error=unused-result' -i sub/termbox_next/makefile
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp bin/ly $out/bin
  '';

  meta = with lib; {
    description = "TUI display manager";
    license = licenses.wtfpl;
    homepage = "https://github.com/cylgom/ly";
    platforms = platforms.linux;
    maintainers = [ maintainers.spacekookie ];
  };
}
