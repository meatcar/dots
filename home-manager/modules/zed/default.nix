{
  config,
  pkgs,
  lib,
  nixpkgs-unstable,
  ...
}:
let
  version = "0.233.6";
  src = nixpkgs-unstable.fetchFromGitHub {
    owner = "zed-industries";
    repo = "zed";
    tag = "v${version}";
    hash = "sha256-VdCnZpNvjv9Soldpz7ZlnI6Lp6uFZqF6zVVo4+jcu/o=";
  };
in
{
  programs.zed-editor.enable = true;
  programs.zed-editor.package = nixpkgs-unstable.zed-editor.overrideAttrs (_: {
    inherit version src;
    cargoDeps = nixpkgs-unstable.rustPlatform.fetchCargoVendor {
      inherit src;
      hash = "sha256-aKVal37mCPgKBdYBgmUZZ3F6zBzUu85IsvLECK4+Ldg=";
      postBuild = "rm -rf $out/git/*/candle-book/";
    };
  });
  # some programs assume zeditor is zed
  home.packages = [
    (pkgs.writeShellScriptBin "zed" ''
      # TODO: remove after updating AMD drivers.
      # fix for zed-editor not starting in wayland sessions
      # see https://github.com/zed-industries/zed/issues/35948#issuecomment-3189128449
      # export WAYLAND_DISPLAY=""
      ${lib.getExe config.programs.zed-editor.package} "$@"
    '')
  ]
  ++ (with pkgs; [
    nodejs
    package-version-server
    prettier # default built-in formatter
  ]);
}
