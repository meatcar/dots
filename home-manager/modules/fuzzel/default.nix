{config, ...}: {
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font = config.gtk.font.name;
        dpi-aware = "no"; # Sway does this for us
        icon-theme = config.gtk.iconTheme.name;
        terminal = "${config.programs.ghostty.package}/bin/ghostty";
        width = 50;
      };
      colors = {
        background = "000000f0";
        border = "88c0d0f0";
        selection = "00bcd4f0";
        text = "888888f0";
        selection-text = "eeeeeef0";
        match = "fffffff0";
        selection-match = "fffffff0";
      };
    };
  };
}
