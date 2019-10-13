{:user {:plugins [[cider/cider-nrepl "0.22.4"]
                  [lein-cljfmt "0.6.4"]
                  [lein-pprint "1.2.0"]
                  [lein-clojars "0.9.1"]
                  [lein-create-template "0.2.0"]
                  [lein-exec "0.3.7"]
                  [lein-kibit "0.1.7"]
                  [refactor-nrepl "2.5.0-SNAPSHOT"]
                  [lein-ancient "0.6.15"]
                  [jonase/eastwood "0.3.6"]
                  [lein-try "0.4.3"]
                  [lein-cloverage "1.1.2"]
                  [lein-autoreload "0.1.1"]]
        :middleware [cider-nrepl.plugin/middleware
                     refactor-nrepl.plugin/middleware]
        :dependencies [[nrepl "0.6.0"]
                       [fipp "0.6.21"]
                       [org.clojure/tools.namespace "0.3.1"]]}}

