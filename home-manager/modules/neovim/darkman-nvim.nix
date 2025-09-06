{
  buildGoModule,
  fetchFromGitHub,
  vimUtils,
  ...
}:
let
  pname = "darkman.nvim";
  version = "2025-02-01";

  src = fetchFromGitHub {
    owner = "4e554c4c";
    repo = pname;
    rev = "2213b2b484606a20e260bb14b907586d7c6e7eaf";
    sha256 = "sha256-bNLrONEOlDwm899lbvvCmI+mj1mt6CFyTeOQC56qF00=";
  };

  package = buildGoModule {
    inherit pname src version;

    vendorHash = "sha256-HpyKzvKVN9hVRxxca4sdWRo91H32Ha9gxitr7Qg5MY8=";
  };
in
vimUtils.buildVimPlugin {
  inherit pname src version;

  postInstall = ''
    ln -s ${package}/bin $out/bin
  '';

  meta.homepage = "https://github.com/4e554c4c/darkman.nvim";
}
