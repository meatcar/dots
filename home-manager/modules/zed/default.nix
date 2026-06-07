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
    prettier # default built-in formatter
  ]);
}
