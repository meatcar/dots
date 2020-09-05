{ config, pkgs, ... }:
{
  home.packages = [
    pkgs.clojure
    ## linters
    # pkgs.clj-kondo is too heavy, as it pulls in graalvm
    (pkgs.writeShellScriptBin "clj-kondo" ''
      clj -A:clj-kondo "$@"
    ''
    )
    # pkgs.clj-kondo
    pkgs.joker
  ];
  xdg.configFile."clojure/deps.edn".source = ./deps.edn;
  home.file.".shadow-cljs/config.edn".source = ./shadow-cljs.edn;
}
