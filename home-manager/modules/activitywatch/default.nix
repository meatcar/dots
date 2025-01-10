{pkgs, ...}: {
  services.activitywatch = {
    enable = true;
    package = pkgs.aw-server-rust;
    watchers = {
      # awatcher = {
      #   package = pkgs.awatcher;
      # };
      # aw-watcher-afk = {
      #   package = pkgs.aw-server-rust;
      # };
    };
  };
}
