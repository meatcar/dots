{
  # FIXME: blocked by https://github.com/NixOS/nixpkgs/issues/404113
  # imports = [
  #   ./rules/systemd/resolved.nix
  #   ./rules/systemd/timesyncd.nix
  #   ./rules/services/geoclue2.nix
  #   ./rules/services/networkmanager.nix
  #   ./rules/services/activitywatch.nix
  # ];
  services.opensnitch.enable = true;
}
