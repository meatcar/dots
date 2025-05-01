{pkgs, ...}: {
  services.swaync = {
    enable = true;
    settings = {
      widgets = [
        "title"
        "notifications"
        "backlight"
        "volume"
        "mpris"
        "dnd"
        "inhibitors"
      ];
      widget-config = {
        backlight = {
          label = "󰃟 ";
          device = "amdgpu_bl1";
        };
        volume = {
          label = "󰕾 ";
          expand-button-label = "";
          collapse-button-label = "";
          show-per-app = true;
          show-per-app-icon = true;
          show-per-app-label = false;
        };
        title = {
          text = "Notifications";
          clear-all-button = true;
          button-text = "󰎟";
        };
      };
    };
    style = let
      version = "0.2.3";
      cattpuccin-mocha = builtins.readFile (pkgs.fetchurl {
        url = "https://github.com/catppuccin/swaync/releases/download/v${version}/mocha.css";
        hash = "sha256-Hie/vDt15nGCy4XWERGy1tUIecROw17GOoasT97kIfc=";
      });
    in ''
      ${cattpuccin-mocha}

      * {
        font-family: "Symbols Nerd Font", sans-serif;
      }
    '';
  };
}
