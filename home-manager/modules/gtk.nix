{pkgs, ...}: {
  home.packages = with pkgs; [dconf glib.bin];
  gtk = {
    enable = true;
  };
}
