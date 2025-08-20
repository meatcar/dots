{
  pkgs,
  specialArgs,
  ...
}:
{
  programs.zed-editor.enable = true;
  programs.zed-editor.package = specialArgs.nixpkgs-unstable.zed-editor;
  # some programs assume zeditor is zed
  home.packages = [
    (pkgs.writeShellScriptBin "zed" ''
      zeditor "$@"
    '')
  ]
  ++ (with pkgs; [
    nodejs
    package-version-server
  ]);
}
