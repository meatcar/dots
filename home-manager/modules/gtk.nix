{ pkgs, ... }:
{
  home.packages = [ pkgs.dconf ];
  gtk = {
    enable = true;
    iconTheme.package = pkgs.papirus-icon-theme;
    iconTheme.name = "Papirus";
    theme.package = pkgs.pop-gtk-theme;
    theme.name = "Pop-dark";
    font.package = pkgs.inter;
    font.name = "Inter 10";
  };
}
