{ config, pkgs, ... }:
{
  home.packages = [ pkgs.clojure ];
  xdg.configFile."clojure/deps.edn".source = ./deps.edn;
  home.file.".shadow-cljs/config.edn".source = ./shadow-cljs.edn;
}
