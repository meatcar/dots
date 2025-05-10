{
  config,
  pkgs,
  lib,
  ...
}:
let
  gebaar-libinput = pkgs.gebaar-libinput.overrideAttrs (_attrs: rec {
    version = "2019-11-29";
    src = pkgs.fetchFromGitHub {
      owner = "osleg";
      repo = "gebaar-libinput-fork";
      rev = "8c3f67db473896fd8d369d7f8492a8c8e83b44a1";
      sha256 = "05g6dd6h2b0l2038hq0b10di2j44w4j9g8dcvbzh1mz35w2qkd9a";
      fetchSubmodules = true;
    };
  });
in
{
  programs.fish.loginShellInit = ''
    if test (id --user $USER) -ge 1000 && test (tty) = "/dev/tty1"
      exec sway
    end
  '';

  wayland.windowManager.sway =
    let
      border = 3;
    in
    {
      enable = true;
      systemd.enable = true;
      extraSessionCommands = ''
        export SDL_VIDEODRIVER=wayland
        export QT_QPA_PLATFORM=wayland
        export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
        export _JAVA_AWT_WM_NONREPARENTING=1
        export _JAVA_OPTIONS=-Dawt.useSystemAAFontSettings=on
      '';

      extraConfig = ''
        titlebar_padding ${toString (border * 4)} ${toString (border * 2)}
        title_align left

        titlebar_border_thickness ${toString border}

        default_orientation auto
      '';

      config = {
        modifier = "Mod4";
        bars = [ ];

        colors = {
          focused = {
            background = "#323232";
            border = "#BA5E50";
            text = "#ffffff";
            childBorder = "#BA5E50";
            indicator = "#884488";
          };
          focusedInactive = {
            background = "#323232";
            border = "#323232";
            text = "#ffffff";
            childBorder = "#323232";
            indicator = "#442244";
          };
          unfocused = {
            background = "#101010";
            border = "#101010";
            text = "#aaaaaa";
            childBorder = "#101010";
            indicator = "#000000";
          };
          urgent = {
            background = "#ffaa55";
            border = "#ffaa55";
            text = "#ffffff";
            childBorder = "#ffaa55";
            indicator = "#ffaa55";
          };
        };

        floating = {
          inherit border;
          criteria = [
            { title = "^wl-clipboard$"; }
            { app_id = "org.kde.kdesu"; }
            { title = "Farge"; }
          ];
        };
        fonts = {
          names = [ "sansSerif" ];
          size = 10.0;
        };
        gaps = {
          inner = 10;
          smartBorders = "on";
          smartGaps = true;
        };
        menu = "${pkgs.wldash}/bin/wldash";

        terminal = "${pkgs.alacritty}/bin/alacritty";

        window = {
          inherit border;
          hideEdgeBorders = "smart";
          commands = [
            {
              command = "inhibit_idle fullscreen";
              criteria = {
                class = "^.*";
              };
            }
            {
              command = "inhibit_idle fullscreen";
              criteria = {
                app_id = "^.*";
              };
            }
            {
              command = "floating enable, border none";
              criteria = {
                app_id = "fzf";
              };
            }
          ];
        };

        workspaceAutoBackAndForth = true;

        modes = {
          resize = {
            l = "resize shrink width 10px";
            j = "resize grow height 10px";
            k = "resize shrink height 10px";
            h = "resize grow width 10px";
            "Shift+l" = "resize shrink width 100px";
            "Shift+j" = "resize grow height 100px";
            "Shift+k" = "resize shrink height 100px";
            "Shift+h" = "resize grow width 100px";
            Escape = "mode default";
            Return = "mode default";
          };
          "wallpaper [p|n|r|d]" = {
            n = "exec wallp -n, mode default";
            p = "exec wallp -p, mode default";
            r = "exec wallp -r, mode default";
            d = "exec wallp -d, mode default";
            Escape = "mode default";
            Return = "mode default";
          };
        };

        input = {
          "type:keyboard" = {
            xkb_options = "caps:escape";
          };
          "type:touchpad" = {
            dwt = "enabled";
            tap = "enabled";
            natural_scroll = "enabled";
            middle_emulation = "enabled";
            drag = "enabled";
            scroll_factor = "0.1";
          };
        };

        output = {
          "*" = {
            bg = "~/.wallpaper fill";
          };
        };

        startup = [
          {
            command = ''
              ${pkgs.swayidle}/bin/swayidle -w \
                 timeout 300 "swaylock -f" \
                 timeout 600 'swaymsg "output * dpms off"' \
                      resume 'swaymsg "output * dpms on"' \
                 before-sleep "swaylock -f"
            '';
          }
          { command = "${pkgs.mako}/bin/mako"; }
          { command = "${gebaar-libinput}/bin/gebaard -b"; }
          {
            always = true;
            command =
              let
                waybarWrapper = pkgs.writeShellScript "waybarWrapper" ''
                  # kill waybar with -9 (SIGKILL) because it doesn't propagate SIGTERM to children
                  pkill -9 waybar
                  ${pkgs.waybar}/bin/waybar
                '';
              in
              "${waybarWrapper}";
          }
        ];

        keybindings =
          let
            mod = config.wayland.windowManager.sway.config.modifier;
            inherit (config.wayland.windowManager.sway.config) terminal;
            inherit (config.wayland.windowManager.sway.config) menu;
            fzfOpts = "--multi --revers --border --cycle";
          in
          lib.mkDefault {
            "${mod}+1" = "workspace number 1";
            "${mod}+2" = "workspace number 2";
            "${mod}+3" = "workspace number 3";
            "${mod}+4" = "workspace number 4";
            "${mod}+5" = "workspace number 5";
            "${mod}+6" = "workspace number 6";
            "${mod}+7" = "workspace number 7";
            "${mod}+8" = "workspace number 8";
            "${mod}+9" = "workspace number 9";
            "${mod}+0" = "workspace number 10";
            "${mod}+Shift+1" = "move container to workspace number 1";
            "${mod}+Shift+2" = "move container to workspace number 2";
            "${mod}+Shift+3" = "move container to workspace number 3";
            "${mod}+Shift+4" = "move container to workspace number 4";
            "${mod}+Shift+5" = "move container to workspace number 5";
            "${mod}+Shift+6" = "move container to workspace number 6";
            "${mod}+Shift+7" = "move container to workspace number 7";
            "${mod}+Shift+8" = "move container to workspace number 8";
            "${mod}+Shift+9" = "move container to workspace number 9";
            "${mod}+Shift+0" = "move container to workspace number 10";
            "${mod}+j" = "focus down";
            "${mod}+k" = "focus up";
            "${mod}+h" = "focus left";
            "${mod}+l" = "focus right";
            "${mod}+Shift+j" = "move down";
            "${mod}+Shift+k" = "move up";
            "${mod}+Shift+h" = "move left";
            "${mod}+Shift+l" = "move right";
            "${mod}+Shift+Left" = "move workspace to output left";
            "${mod}+Shift+Right" = "move workspace to output right";
            "${mod}+Shift+Up" = "move workspace to output up";
            "${mod}+Shift+Down" = "move workspace to output down";
            "${mod}+Return" = "exec ${terminal}";
            "${mod}+Shift+Return" = "exec cwd-term ${terminal}";
            "${mod}+e" = "exec ${pkgs.xfce.thunar}/bin/thunar";
            "${mod}+d" = "kill";
            "${mod}+Shift+d" =
              "exec fzf-wrap-exec \"ps -f -U $USER | sed 1d | fzf ${fzfOpts} | awk '{print \\$2'}' | xargs kill\"";
            "${mod}+p" = "exec ${menu}";
            "${mod}+Shift+p" =
              "exec fzf-wrap-exec \"dmenu_path | fzf ${fzfOpts} --history=\$HOME/.cache/sway/launch-hist\"";
            "${mod}+Shift+s" = "exec slurp | xargs -i grim -g {} - | wl-copy";
            "${mod}+n" = "exec makoctl dismiss";
            "${mod}+Shift+n" = "exec makoctl dismiss --all";
            "${mod}+q" = "reload";
            "${mod}+Shift+q" =
              "exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -b 'Yes, exit sway' 'swaymsg exit'";

            "XF86AudioRaiseVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ +1%";
            "XF86AudioLowerVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ -1%";
            "XF86AudioMute" = "exec pactl set-sink-mute @DEFAULT_SINK@ toggle";
            "XF86AudioMicMute" = "exec pactl set-source-mute @DEFAULT_SOURCE@ toggle";
            "XF86MonBrightnessDown" = "exec brightnessctl set 5%-";
            "XF86MonBrightnessUp" = "exec brightnessctl set +5%";

            "${mod}+x" = "exec swaylock";
            "${mod}+s" = "split toggle";
            "${mod}+t" = "layout toggle all";
            "${mod}+f" = "fullscreen";
            "${mod}+Shift+space" = "floating toggle";
            "${mod}+space" = "focus mode_toggle";
            "${mod}+a" = "focus parent";
            "${mod}+z" = "scratchpad show";
            "${mod}+Shift+z" = "move scratchpad";
            "${mod}+y" = "exec safestream";
            "${mod}+grave" = ''
              fullscreen disable, \
                floating enable, \
                border pixel $border, \
                resize set height 400, \
                sticky enable, \
                move window to position 0 0
            '';
            "${mod}+r" = "mode resize";
            "${mod}+w" = "mode \"wallpaper [p|n|r|d]\"";
          };
      };
    };

  xdg.configFile."gebaar/gebaard.toml".text =
    let
      swaymsg = "${pkgs.sway}/bin/swaymsg";
    in
    ''
      [swipe.settings]
      threshold = 0.5
      one_shot = false
      trigger_on_release = false

      [swipe.commands.three]
      left_up = ""
      right_up = ""
      up = "${swaymsg} focus up"
      left_down = ""
      right_down = ""
      down = "${swaymsg} focus down"
      left = "${swaymsg} focus left"
      right = "${swaymsg} focus right"

      [swipe.commands.four]
      left_up = ""
      right_up = ""
      up = "${config.wayland.windowManager.sway.config.menu}"
      left_down = ""
      right_down = ""
      down = "pkill ${builtins.baseNameOf config.wayland.windowManager.sway.config.menu}"
      left = "${swaymsg} workspace prev"
      right = "${swaymsg} workspace next"
    '';
}
