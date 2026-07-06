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

    # DMS's matugen writes dank-colors.css (libadwaita @define-color names) into
    # each gtk-N.0 dir on every recolor. Pull it in so GTK apps track the shell's
    # Material You palette. GTK4/libadwaita apps consume these names natively and
    # still follow the prefer-dark color-scheme; GTK3 (stock Adwaita) picks up
    # the named colors only loosely without adw-gtk3, but the import is harmless.
    # @import must lead the file, so keep this the whole of extraCss.
    gtk3.extraCss = ''@import url("dank-colors.css");'';
    gtk4.extraCss = ''@import url("dank-colors.css");'';
  };
}
