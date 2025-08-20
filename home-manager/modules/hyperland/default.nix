{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ../wayland
    ../waybar
    ../fuzzel
    ../gammastep.nix
    ../swaync
    ../nautilus
  ];
  home.packages = with pkgs; [
    swaylock
    fuzzel
    grim
    grimblast
  ];
  services.gnome-keyring.enable = true;
  services.swayosd.enable = true;
  services.copyq.enable = true;
  home.sessionVariables = {
    XDG_SCREENSHOTS_DIR = "${config.home.homeDirectory}/Pictures/Screenshots";
  };
  # wayland.windowManager.hyprland.plugins = [
  #   pkgs.hyprlandPlugins.hyprscroller
  # ];

  wayland.windowManager.hyprland = {
    enable = true;

    # set the Hyprland and XDPH packages to null to use the ones from the NixOS module
    package = null;
    portalPackage = null;

    systemd.variables = [ "--all" ];
    settings = {
      "$mod" = "SUPER";

      monitor = [
        "eDP-1, 1920x1200@60, 0x0, 1"
        # portable monitor
        "DP-2, 1920x1080@60, 1920x0, 1"
        # 'rents office
        "DVI-I-2, 2560x1080@59.97800, 1920x0, 1"
        "DVI-I-1, 1920x1080@60, 4480x0, 1"
      ];
      general = {
        allow_tearing = false;
        border_size = 2;
        gaps_in = 8;
        gaps_out = 8;
        layout = "master";
      };
      decoration = {
        rounding = 8;
        blur.enabled = false;
        shadow.enabled = false;
      };
      group.groupbar.font_size = 12;
      input.touchpad = {
        natural_scroll = true;
        middle_button_emulation = true;
        drag_lock = true;
      };
      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        font_family = "sans-serif";
        mouse_move_enables_dpms = true;
        key_press_enables_dpms = true;
        vfr = true;
      };
      animation = [
        "windows, 1, 2, default"
      ];
      bind = [
        "$mod, Return, exec, ghostty"
        "$mod, P, exec, fuzzel"
        "$mod SHIFT, P, exec, 1password --quick-access"
        "$mod SHIFT, N, exec, swaync-client -t -sw"
        "$mod, N, exec, swaync-client --hide-latest -sw"
        "$mod, V, exec, copyq toggle"
        "$mod, Period, exec, ${lib.getExe pkgs.smile}"
        "$mod, C, exec, ${lib.getExe pkgs.hyprpicker}"
        "$mod, E, exec, ${lib.getExe pkgs.nautilus}"
        ", print, exec, ${lib.getExe pkgs.grimblast} -freeze copysave area"

        "$mod SHIFT, Q, exit"
        "$mod, D, killactive"
        "$mod, Space, togglefloating"
        "$mod, T, togglegroup"
        "$mod, J, movefocus, d"
        "$mod, K, movefocus, u"
        "$mod, H, movefocus, l"
        "$mod, L, movefocus, r"
        "$mod SHIFT, J, movewindoworgroup, d"
        "$mod SHIFT, K, movewindoworgroup, u"
        "$mod SHIFT, H, movewindoworgroup, l"
        "$mod SHIFT, L, movewindoworgroup, r"
        "$mod, Tab, changegroupactive, f"
        "$mod SHIFT, Tab, changegroupactive, b"
        "$mod ALT, J, movecurrentworkspacetomonitor, d"
        "$mod ALT, K, movecurrentworkspacetomonitor, u"
        "$mod ALT, H, movecurrentworkspacetomonitor, l"
        "$mod ALT, L, movecurrentworkspacetomonitor, r"
      ]
      ++ (
        # workspaces
        # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
        builtins.concatLists (
          builtins.genList (
            i:
            let
              ws = i + 1;
            in
            [
              "$mod, code:1${toString i}, workspace, ${toString ws}"
              "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
            ]
          ) 9
        )
      );
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
      binde = [
        ", XF86AudioRaiseVolume, exec, swayosd-client --output-volume=raise"
        ", XF86AudioLowerVolume, exec, swayosd-client --output-volume=lower"
        ", XF86AudioMute, exec, swayosd-client --output-volume=mute-toggle"
        ", XF86AudioMicMute, exec, swayosd-client --input-volume=mute-toggle"
        ", XF86MonBrightnessUp, exec, swayosd-client --brightness=raise"
        ", XF86MonBrightnessDown, exec, swayosd-client --brightness=lower"
      ];
    };
  };
}
