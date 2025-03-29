{pkgs, ...}: {
  home.packages = [
    pkgs.evince
  ];
  xdg.mimeApps.defaultApplications = {
    "application/pdf" = "org.gnome.Evince.desktop";
  };
}
