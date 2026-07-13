{
  config,
  pkgs,
  lib,
  nixpkgs-unstable,
  ...
}:
{
  programs.zed-editor.enable = true;
  programs.zed-editor.package = nixpkgs-unstable.zed-editor;
  # some programs assume zeditor is zed
  home.packages = [
    (pkgs.writeShellScriptBin "zed" ''
      ${lib.getExe config.programs.zed-editor.package} "$@"
    '')
  ]
  ++ (with pkgs; [
    nodejs
    package-version-server
  ])
  ++ [
    # default built-in formatter
    # FIXME(prettier-pnpm-cve): stable prettier builds with insecure
    # pnpm-9.15.9 (CVE-2026-55699); use unstable until 26.05 catches up
    nixpkgs-unstable.prettier
  ];
}
