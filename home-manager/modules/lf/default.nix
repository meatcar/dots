{ pkgs, ... }:
{
  programs.lf = {
    enable = true;
    settings = {
      drawbox = true;
      hidden = true;
      icons = true;
      ignorecase = true;
      smartcase = true;
      ratios = [
        1
        2
        3
      ];
      scrolloff = 4;
    };
    commands.bulk-rename = ''$printf '%s\n' "$fx" | ${pkgs.moreutils}/bin/vidir -'';
    keybindings = {
      "<enter>" = "open";
      "<esc>" = "quit";
      "?" = "maps";
      i = ''$bat --paging=always --style=plain --color=always -- "$f"'';
      r = "bulk-rename";
    };
  };

  home.packages = [ pkgs.moreutils ];

  xdg.configFile = {
    "lf/colors".source = ./colors;
    "lf/icons".source = "${pkgs.lf.src}/etc/icons_colored.example";
  };
}
