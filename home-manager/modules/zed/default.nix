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
    # TODO: use default nodejs once nixos-26.05 Node 24 links brotli 1.2.1 (CVE-2026-111497).
    # see https://nixpk.gs/pr-tracker.html?pr=577244
    nodejs_22
    package-version-server
  ])
  ++ [
    # default built-in formatter
    # FIXME(prettier-pnpm-cve): stable prettier builds with insecure
    # pnpm-9.15.9 (CVE-2026-55699); use unstable until 26.05 catches up
    # TODO: use default nodejs once nixos-unstable Node 24 links brotli 1.2.1 (CVE-2026-111497).
    # see https://nixpk.gs/pr-tracker.html?pr=577208
    (nixpkgs-unstable.prettier.override { nodejs = nixpkgs-unstable.nodejs_22; })
  ];
}
