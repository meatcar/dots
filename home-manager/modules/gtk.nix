{pkgs, ...}: {
  home.packages = with pkgs; [dconf glib.bin];
  gtk = {
    enable = true;
    iconTheme.package = pkgs.papirus-icon-theme;
    iconTheme.name = "Papirus";
    cursorTheme.package = pkgs.posy-cursors;
    cursorTheme.name = "Posy_Cursor";
    cursorTheme.size = 16;
  };
}
