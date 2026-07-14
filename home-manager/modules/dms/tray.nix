# UPSTREAM(dank-material-shell): claim org.kde.StatusNotifierWatcher before
# signaling readiness, so After=dms.service alone is enough for tray apps.
#
# 1Password registers its tray icon exactly once at startup; dms's SNI watcher
# appears async after the unit is active, so wait on the bus name first.
{ pkgs, ... }:
{
  systemd.user.services."1password" = {
    Unit = {
      After = [ "dms.service" ];
      BindsTo = [ "dms.service" ];
    };
    Service.ExecStartPre = "${pkgs.glib.bin}/bin/gdbus wait --session --timeout 30 org.kde.StatusNotifierWatcher";
  };
}
