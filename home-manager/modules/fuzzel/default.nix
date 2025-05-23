{ config, pkgs, ... }:
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
        use-bold = true;
        prompt = "🫴  ";
        # hide-before-typing = true;
      };
      border.width = 2;
      colors = {
        # from https://github.com/catppuccin/fuzzel/blob/main/themes/catppuccin-mocha/sapphire.ini
        background = "1e1e2eff";
        text = "cdd6f4ff";
        prompt = "bac2deff";
        placeholder = "7f849cff";
        input = "cdd6f4ff";
        match = "74c7ecff";
        selection = "585b70ff";
        selection-text = "cdd6f4ff";
        selection-match = "74c7ecff";
        counter = "7f849cff";
        border = "74c7ecff";
      };
    };
  };
  home.packages = [
    (pkgs.writeShellApplication {
      name = "p";
      runtimeInputs = with pkgs; [
        zoxide
        fd
        direnv
        fuzzel
      ];
      text = builtins.readFile ./p.sh;
    })
  ];
}
