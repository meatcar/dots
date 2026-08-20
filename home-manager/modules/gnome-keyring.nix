{ pkgs, ... }:
{
  home.packages = [ pkgs.libsecret ];

  services.gnome-keyring = {
    enable = true;
    components = [
      "pkcs11"
      "secrets"
    ];
  };
}
