{ pkgs, ... }:
{
  programs.rbw = {
    enable = true;
    settings = {
      email = "denysp@alipes.com";
      pinentry = pkgs.pinentry-gnome3;
    };
  };
  # TODO: move to a gtk/gnome package. Needed for pinentry-gnome3
  dbus.packages = [ pkgs.gcr ];
  home.packages = [
    pkgs.pinentry-gnome3
  ];
}
