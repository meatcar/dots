{ pkgs, ... }:
{
  home.packages = with pkgs; [
    dconf
    glib.bin
  ];
  gtk = {
    enable = true;
    iconTheme.package = pkgs.papirus-icon-theme;
    iconTheme.name = "Papirus";
    cursorTheme.package = pkgs.posy-cursors;
    cursorTheme.name = "Posy_Cursor";
    cursorTheme.size = 16;

    # NOTE: Global GTK4 palette overrides break apps that force dark mode.
    gtk3.extraCss = ''@import url("dank-colors.css");'';
  };
}
