{
  config,
  pkgs,
  ...
}: {
  services.spotifyd = {
    enable = true;
    settings = {
      global = {
        username = "meatcar";
        password_cmd = "${pkgs.gnome3.libsecret}/bin/secret-tool lookup app spotifyd username meatcar";
        bitrate = 320;
        cache_path = "${config.xdg.cacheHome}/spotifyd";
        backend = "pulseaudio";
      };
    };
  };
}
