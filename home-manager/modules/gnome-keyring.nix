{
  pkgs,
  osConfig ? { },
  ...
}:
{
  home.packages = [ pkgs.libsecret ];

  services.gnome-keyring = {
    # NOTE: NixOS owns PAM startup and D-Bus activation when enabled.
    enable = !(osConfig.services.gnome.gnome-keyring.enable or false);
    components = [
      "pkcs11"
      "secrets"
    ];
  };
}
