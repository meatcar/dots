{ config, ... }:
{
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font = "sans serif";
        dpi-aware = "no"; # Sway does this for us
        icon-theme = config.gtk.iconTheme.name;
        terminal = "${config.programs.ghostty.package}/bin/ghostty";
        line-height = 28;
      };
      border.width = 2;
    };
  };
}
