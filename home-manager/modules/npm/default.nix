{ pkgs, ... }:
{
  home.file.".npmrc".text = ''
    ignore-scripts=true
    provenance=true
    # save-exact=true
    save-prefix='''
  '';
  home.packages = [ pkgs.npm-check-updates ];
}
