{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [../wayland ../waybar];
  home.packages = with pkgs; [
    swaylock
    fuzzel
  ];
  services.swaync.enable = true;
  services.swayosd.enable = true;
  programs.niri = {
    settings = {
      environment =
        {
          DISPLAY = null;
        };
      input.focus-follows-mouse.enable = true;
      input.touchpad.dwtp = true;
      hotkey-overlay.skip-at-startup = true;
      prefer-no-csd = true;
      layout.preset-column-widths = [
        {proportion = 1.0 / 3.0;}
        {proportion = 1.0 / 2.0;}
        {proportion = 2.0 / 3.0;}
        {proportion = 1.0;}
      ];
      layout.preset-window-heights = [
        {proportion = 1.0 / 3.0;}
        {proportion = 1.0 / 2.0;}
        {proportion = 2.0 / 3.0;}
        {proportion = 1.0;}
      ];
      layout.always-center-single-column = true;
      layout.tab-indicator = {
        position = "top";
      };

      workspaces."1-me" = {name = "me";};
      workspaces."2-work" = {name = "work";};
      workspaces."3-code" = {name = "code";};

      switch-events.lid-close.action.spawn = ["systemctl" "suspend"];
      binds =
        {
          "Mod+Shift+Slash".action.show-hotkey-overlay = {};
          "Mod+Return".action.spawn = "ghostty";
          "Mod+Return".repeat = false;
          "Mod+P".action.spawn = "fuzzel";
          "Mod+P".repeat = false;
          "Mod+Shift+P".action.spawn = "1password --quick-access --ozone-platform-hint=auto";
          "Mod+Shift+P".repeat = false;
          "Mod+Shift+N".action.spawn = "swaync-client -t -sw";
          "Mod+Shift+N".repeat = false;
          "Mod+N".action.spawn = "swaync-client --hide-latest -sw";

          "Mod+Shift+Q".action.quit = {};

          "Mod+D".action.close-window = {};
          "Mod+O".action.focus-window-previous = {};
          "Mod+Z".action.maximize-column = {};
          "Mod+Shift+Z".action.fullscreen-window = {};
          "Mod+B".action.center-window = {};

          "Mod+Tab".action.focus-workspace-down = {};
          "Mod+Shift+Tab".action.focus-workspace-up = {};
          "Mod+Alt+Tab".action.move-column-to-workspace-down = {};
          "Mod+Shift+Alt+Tab".action.move-column-to-workspace-up = {};

          "Mod+H".action.focus-column-or-monitor-left = {};
          "Mod+L".action.focus-column-or-monitor-right = {};
          "Mod+K".action.focus-window-or-monitor-up = {};
          "Mod+J".action.focus-window-or-monitor-down = {};
          "Mod+Shift+H".action.consume-or-expel-window-left = {};
          "Mod+Shift+L".action.consume-or-expel-window-right = {};
          "Mod+Shift+K".action.move-window-up = {};
          "Mod+Shift+J".action.move-window-down = {};
          "Mod+Alt+H".action.move-column-left-or-to-monitor-left = {};
          "Mod+Alt+L".action.move-column-right-or-to-monitor-right = {};
          "Mod+Ctrl+H".action.focus-monitor-left = {};
          "Mod+Ctrl+L".action.focus-monitor-right = {};
          "Mod+Ctrl+J".action.focus-monitor-up = {};
          "Mod+Ctrl+K".action.focus-monitor-down = {};
          "Mod+Ctrl+Shift+H".action.move-window-to-monitor-left = {};
          "Mod+Ctrl+Shift+L".action.move-window-to-monitor-right = {};
          "Mod+Ctrl+Shift+J".action.move-window-to-monitor-up = {};
          "Mod+Ctrl+Shift+K".action.move-window-to-monitor-down = {};
          "Mod+Ctrl+Alt+H".action.move-column-to-monitor-left = {};
          "Mod+Ctrl+Alt+L".action.move-column-to-monitor-right = {};
          "Mod+Ctrl+Alt+J".action.move-column-to-monitor-up = {};
          "Mod+Ctrl+Alt+K".action.move-column-to-monitor-down = {};
          "Mod+Bracketleft".action.swap-window-left = {};
          "Mod+Bracketright".action.swap-window-right = {};
          "Mod+Shift+Bracketleft".action.consume-window-into-column = {};
          "Mod+Shift+Bracketright".action.expel-window-from-column = {};

          "Mod+R".action.switch-preset-column-width = {};
          "Mod+Shift+R".action.switch-preset-window-height = {};
          "Mod+T".action.toggle-column-tabbed-display = {};
          "Mod+Minus".action.set-column-width = "-5%";
          "Mod+Equal".action.set-column-width = "+5%";
          "Mod+0".action.expand-column-to-available-width = {};
          "Mod+Shift+Minus".action.set-window-height = "-5%";
          "Mod+Shift+Equal".action.set-window-height = "+5%";
          "Mod+Shift+0".action.reset-window-height = {};

          "Mod+Space".action.switch-focus-between-floating-and-tiling = {};
          "Mod+Shift+Space".action.toggle-window-floating = {};

          "Print".action.screenshot = {};
          "Mod+Print".action.screenshot-window = {};
          "Mod+Shift+Print".action.screenshot-screen = {};

          "Mod+1".action.focus-workspace = 1;
          "Mod+Shift+1".action.move-window-to-workspace = 1;
          "Mod+Alt+1".action.move-column-to-workspace = 1;
          "Mod+2".action.focus-workspace = 2;
          "Mod+Shift+2".action.move-window-to-workspace = 2;
          "Mod+Alt+2".action.move-column-to-workspace = 2;
          "Mod+3".action.focus-workspace = 2;
          "Mod+Shift+3".action.move-window-to-workspace = 3;
          "Mod+Alt+3".action.move-column-to-workspace = 3;
        }
        // (lib.pipe 9 [
          (builtins.genList (x: x + 1))
          (builtins.map (n: [
            {
              name = "Mod+${builtins.toString n}";
              value = {action.focus-workspace = n;};
            }
            {
              name = "Mod+Shift+${builtins.toString n}";
              value = {action.move-window-to-workspace = n;};
            }
            {
              name = "Mod+Alt+${builtins.toString n}";
              value = {action.move-column-to-workspace = n;};
            }
          ]))
          (lib.flatten)
          (builtins.listToAttrs)
        ]);

      window-rules = [
        {
          geometry-corner-radius = {
            bottom-left = 8.0;
            bottom-right = 8.0;
            top-left = 8.0;
            top-right = 8.0;
          };
          clip-to-geometry = true;
        }
        {
          matches = [{is-floating = true;}];
          shadow.enable = true;
          shadow.draw-behind-window = true;
        }
        {
          matches = [{app-id = "code";}];
          open-on-workspace = "code";
        }
        {
          matches = [{is-window-cast-target = true;}];
          focus-ring.active.color = "#f38ba8";
          focus-ring.inactive.color = "#7d0d2d";
          border.inactive.color = "#7d0d2d";
          shadow.color = "#7d0d2d70";
          tab-indicator.active.color = "#f38ba8";
          tab-indicator.inactive.color = "#7d0d2d";
        }
      ];
    };
  };
}
