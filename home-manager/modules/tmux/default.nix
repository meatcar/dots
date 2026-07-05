{
  pkgs,
  ...
}:
let
  inherit (pkgs) tmuxPlugins;

  # Pre-compile whichkey.yaml → init.tmux at Nix build time so the plugin can
  # load it directly without a runtime Python step (autobuild stays disabled).
  whichkey-init =
    pkgs.runCommand "tmux-which-key-init.tmux" { nativeBuildInputs = [ pkgs.python3 ]; }
      ''
        python3 ${tmuxPlugins.tmux-which-key}/share/tmux-plugins/tmux-which-key/plugin/build.py \
          ${./whichkey.yaml} "$out"
      '';
  aw-watcher-tmux = tmuxPlugins.mkTmuxPlugin {
    pluginName = "aw-watcher-tmux";
    version = "unstable-2023-10-17";
    src = pkgs.fetchFromGitHub {
      owner = "akohlbecker";
      repo = "aw-watcher-tmux";
      rev = "efaa7610add52bd2b39cd98d0e8e082b1e126487";
      hash = "sha256-L6YLyEOmb+vdz6bJdB0m5gONPpBp2fV3i9PiLSNrZNM=";
    };
    rtpFilePath = "aw-watcher-tmux.tmux";
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postInstall = ''
      wrapProgram $out/share/tmux-plugins/aw-watcher-tmux/scripts/monitor-session-activity.sh \
        --prefix PATH : ${
          pkgs.lib.makeBinPath [
            pkgs.curl
            pkgs.tmux
          ]
        }

      # The upstream loader leaks stdout/stderr from the polling loop into
      # tmux's run-shell capture, which corrupts the status bar.
      cat > $out/share/tmux-plugins/aw-watcher-tmux/aw-watcher-tmux.tmux <<'EOF'
      #!${pkgs.runtimeShell}
      CURRENT_DIR="$( cd "$( dirname "''${BASH_SOURCE[0]}" )" && pwd )"
      "$CURRENT_DIR/scripts/monitor-session-activity.sh" >/dev/null 2>&1 &
      disown || true
      EOF
      chmod +x $out/share/tmux-plugins/aw-watcher-tmux/aw-watcher-tmux.tmux
    '';
    meta.description = "ActivityWatch watcher for tmux sessions";
  };
in
{
  imports = [
    ./opensessions.nix
    ./sesh.nix
  ];

  programs.tmux = {
    enable = true;
    keyMode = "vi";
    prefix = "C-a";
    aggressiveResize = true;
    secureSocket = false;
    terminal = "tmux-256color";
    # Use /bin/sh as default-shell so commands passed to split-window (e.g. by
    # opensessions) can use POSIX ${VAR:-default} syntax, which fish rejects.
    # default-command keeps interactive panes running fish.
    shell = "/bin/sh";
    extraConfig = builtins.readFile ./tmux.conf + ''
      set -g default-command ${pkgs.fish}/bin/fish
    '';
    plugins = [
      tmuxPlugins.sensible
      tmuxPlugins.yank
      tmuxPlugins.pain-control
      {
        plugin = tmuxPlugins.prefix-highlight;
        extraConfig = ''
          set -g @prefix_highlight_show_copy_mode "on"
        '';
      }
      aw-watcher-tmux
      {
        plugin = tmuxPlugins.tmux-which-key;
        extraConfig = ''
          set -g @tmux-which-key-xdg-enable 1
          set -g @tmux-which-key-disable-autobuild 1
          set -g @tmux-which-key-xdg-plugin-path tmux/plugins/tmux-which-key
        '';
      }
    ];
  };

  xdg.configFile."tmux/plugins/tmux-which-key/config.yaml".source = ./whichkey.yaml;
  xdg.dataFile."tmux/plugins/tmux-which-key/init.tmux".source = whichkey-init;
}
