{
  programs.spotify-player.enable = true;
  services.spotifyd.enable = true;
  services.spotifyd.settings.global.device_name = "nix";
}
