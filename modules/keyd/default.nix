_: {
  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = [ "*" ];
        settings = {
          main = {
            capslock = "esc";
            "rightcontrol" = "layer(rightcontrol)";
            "wakeup" = "layer(rightcontrol)"; # t14s fn = "wakeup"
          };
          rightcontrol = {
            # mac-ish bindings
            "left" = "home";
            "right" = "end";
            "up" = "pageup";
            "down" = "pagedown";

            # makes sence on a leopold fc660c
            "insert" = "volumeup";
            "delete" = "volumedown";
            "backspace" = "mute";
          };
        };
      };
    };
  };
}
