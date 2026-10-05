{
  config,
  osConfig,
  pkgs,
  lib,
  nixpkgs-unstable,
  ...
}:
let
  # NOTE: Meet's auto-gain control drags the system mic volume around;
  # this keeps Chromium AGC digital-only.
  chromiumFlags = [ "--disable-features=WebRtcAllowInputVolumeAdjustment" ];
in
{
  imports = [
    ../common.nix
    ../../modules/agenix
    ../../modules/gtk.nix
    ../../modules/gnome-keyring.nix
    ../../modules/impermanence-copy-paths
    # ../../modules/firefox
    ../../modules/zen
    ../../modules/darkman
    ../../modules/niri
    ../../modules/1password
    ../../modules/ssh-agent-mux
    ../../modules/bitwarden
    # ../../modules/docker
    ../../modules/activitywatch
    ../../modules/ghostty
    ../../modules/cliphist
    # ../../modules/obsidian
    ../../modules/ai
    # ../../modules/paseo
    ../../modules/vscode
    ../../modules/zed
    ../../modules/jira
    ../../modules/go
    ../../modules/calendar
    ../../modules/evince
    ../../modules/spotify
    ../../modules/television
    ../../modules/kdeconnect
    ../../modules/mime-apps
    ../../modules/voice
    ../../modules/netdata-notify
    ../../modules/searxng
    ../../modules/qbittorrent
    ../../modules/figma-agent
    ../../modules/audio-mixers
    ../../modules/awtrix-pipewire-on-air
    ./impermanence.nix
  ];

  # Atomic file-manager switch: flip this one word and rebuild. See
  # ../../modules/file-manager and the gated xdg.portal.extraPortals in
  # systems/watson/default.nix.
  me.fileManager = "dolphin";

  programs._1password.package = osConfig.programs._1password.package;
  programs._1password-gui.package = osConfig.programs._1password-gui.package;

  home.packages =
    with pkgs;
    [
      pciutils
      code-cursor
      slack
      calibre
      gimp
      inkscape
      loupe
      pantheon.epiphany
      cameractrls-gtk4
      mpv
      ffmpeg
      # dev
      cloudflared
      weave-merge
    ]
    ++ (with nixpkgs-unstable; [
      (microsoft-edge.override { commandLineArgs = chromiumFlags; })
      vivaldi-ffmpeg-codecs
      widevine-cdm
      (vivaldi.override {
        proprietaryCodecs = true;
        enableWidevine = true;
        commandLineArgs = chromiumFlags;
      })
      railway
    ]);

  programs.fish.completions.railway.body = ''
    ${nixpkgs-unstable.railway}/bin/railway completion fish | source
  '';

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "microsoft-edge"
      "slack"
      "vivaldi"
      "vscode"
      "obsidian"
    ];

  programs.chromium = {
    enable = true;
    commandLineArgs = chromiumFlags;
  };

  services.syncthing.enable = true;

  # traefik cannot front this; it has no way to start a stopped container.
  services.searxng = {
    enable = true;
    environmentFile = config.age.secrets.searxngEnv.path;
  };

  systemd.user.services.awtrix-pipewire-on-air.Service.Environment = [
    "AWTRIX_HOST=awtrix_bbff64.local"
    ''"AWTRIX_IGNORE_APPS=cava,pavucontrol,PulseAudio Volume Control"''
  ];
}
