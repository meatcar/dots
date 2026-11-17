{ inputs, pkgs, ... }:
{
  imports = [ inputs.bw-broker.homeManagerModules.default ];

  services.bw-broker = {
    enable = true;
    email = "denysp@alipes.com";
    unlockTimeout = 900;
  };

  # TODO: move to a gtk/gnome package. Needed for pinentry-gnome3
  dbus.packages = [ pkgs.gcr ];
  home.packages = [
    pkgs.pinentry-gnome3
  ];
}
