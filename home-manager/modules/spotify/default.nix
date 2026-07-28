{
  config,
  pkgs,
  ...
}:
let
  name = "nix";
  getClientId = pkgs.writeShellScript "getClientId" ''
    # trim trailing newline
    ${pkgs.gnused}/bin/sed -Ez 's/\n+$//' "${config.age.secrets.spotifyClientId.path}"
  '';
in
{
  programs.spotify-player = {
    enable = true;
    settings = {
      default_device = name;
      client_id_command = {
        command = "${getClientId}";
        args = [ ];
      };
      enable_notify = false;
      play_icon = " ";
      pause_icon = " ";
      enable_media_control = true;
      seek_duration_secs = 10;
      liked_icon = "󰋑 ";
      border_type = "Hidden";
      progress_bar_type = "Rectangle";
      layout.playback_window_position = "Bottom";
      device = {
        name = "${name}-cli";
        device_type = "computer";
        bitrate = 320;
        audio_cache = true;
        autoplay = true;
      };
    };
    actions = [
      {
        action = "ToggleLiked";
        key_sequence = "t l";
        target = "PlayingTrack";
      }
      {
        action = "AddToLibrary";
        key_sequence = "C-a";
        target = "PlayingTrack";
      }
      {
        action = "Follow";
        key_sequence = "C-f";
        target = "PlayingTrack";
      }
    ];
    keymaps = [
      {
        command = "Shuffle";
        key_sequence = "t s";
      }
      {
        command = "Repeat";
        key_sequence = "t r";
      }
      {
        command = "ResumePause";
        key_sequence = "t space";
      }
      {
        command = "Mute";
        key_sequence = "t m";
      }
      {
        command = "SwitchDevice";
        key_sequence = "t d";
      }
      {
        command = "SwitchTheme";
        key_sequence = "t t";
      }
    ];
  };

  services.spotifyd = {
    enable = true;
    settings.global = {
      device_name = name;
      device_type = "computer";
      # volume-normalisation = false;
      bitrate = 320;
      autoplay = false;
      # librespot picks the first compiled-in backend when this is unset, which
      # is alsa. That works via the alsa->pipewire plugin, but bypasses the
      # PipeWire graph: no per-app volume, no runtime sink switching, and the
      # stream never shows up as a node. Ask for pulse (i.e. pipewire-pulse).
      backend = "pulseaudio";
    };
  };

  # spotifyd has no ordering deps, so it can start before the network is up
  # and libmdns fails ENODEV. librespot retries its connection, but zeroconf
  # never does, so the daemon stays invisible to Spotify Connect until a
  # manual restart. network-online.target doesn't exist in the user manager,
  # so poll for a routable address before exec instead.
  systemd.user.services.spotifyd.Service = {
    ExecStartPre = "${pkgs.writeShellScript "wait-for-network" ''
      for _ in $(seq 1 60); do
        if ${pkgs.iproute2}/bin/ip -4 route show default | ${pkgs.gnugrep}/bin/grep -q .; then
          exit 0
        fi
        sleep 1
      done
      # Fall through and let librespot's own retry loop handle it.
      exit 0
    ''}";
  };
}
