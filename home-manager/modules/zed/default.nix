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
