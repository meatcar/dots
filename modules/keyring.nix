_: {
  services.gnome.gnome-keyring.enable = true;
  programs.seahorse.enable = true;

  # Auto-unlock keyring on login via display manager
  security.pam.services.login.enableGnomeKeyring = true;
}
