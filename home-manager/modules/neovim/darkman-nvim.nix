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
    rev = "300b441eaa1187ffaa541fc54971ee8ce731884f";
    sha256 = "sha256-f0gL0PUalz+A+OhnR0D+l8DEsdt30Ww17JQ7vI5c08I=";
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
