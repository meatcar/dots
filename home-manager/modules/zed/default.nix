{ pkgs, ... }:
{
  programs.zed-editor.enable = true;
  # some programs assume zeditor is zed
  home.packages =
    [
      (pkgs.writeShellScriptBin "zed" ''
        zeditor "$@"
      '')
    ]
    ++ (with pkgs; [
      package-version-server
    ]);
}
