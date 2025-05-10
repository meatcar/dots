{ pkgs, ... }:
{
  home.packages = [ pkgs.leiningen ];
  home.file.".lein/profiles.clj".source = ./profiles.clj;
}
