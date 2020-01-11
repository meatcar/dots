{ config, pkgs, ... }:
let
  inherit (pkgs) tmuxPlugins;
in
{
  programs.tmux = {
    enable = true;
    extraConfig = builtins.readFile ./tmux.conf;
    aggressiveResize = true;
    baseIndex = 1;
    secureSocket = false;
    escapeTime = 0;
    keyMode = "vi";
    shortcut = "a";
    terminal = "tmux-256color";
    plugins = [
      tmuxPlugins.yank
      tmuxPlugins.pain-control
      tmuxPlugins.ctrlw
      {
        plugin = tmuxPlugins.resurrect;
        extraConfig = ''
          set -g @resurrect-process "mosh-client neomutt nvim weechat"
        '';
      }
      {
        plugin = tmuxPlugins.continuum;
        extraConfig = ''
          set -g @continuum-restore "on"
        '';
      }
      {
        plugin = tmuxPlugins.prefix-highlight;
        extraConfig = ''
          set -g @prefix_highlight_show_copy_mode "on"
        '';
      }
    ];
  };

  home.packages = [];
}
