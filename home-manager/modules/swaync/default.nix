{specialArgs, ...}: {
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
      cattpuccin-mocha = "${specialArgs.inputs.catppuccin-swaync}";
    in ''
      ${builtins.readFile cattpuccin-mocha}

      * {
        font-family: "Symbols Nerd Font", sans-serif;
      }
    '';
  };
}
