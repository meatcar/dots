{ config, pkgs, ... }:
{
  programs.kakoune = {
    enable = true;
    config = {
      showMatching = true;
      ui = {
        enableMouse = true;
        assistant = "none";
      };
      wrapLines = {
        enable = true;
        indent = true;
        marker = "⏎";
        word = true;
      };
    };
    extraConfig = ''

      ${builtins.readFile ./kakrc}
    '';
  };

  xdg.configFile."kak/plugins/plug.kak".source = config.niv."plug.kak";

  nixpkgs.overlays = [
    (
      self: super: {
        kakoune = super.kakoune.override {
          configure = { plugins = [ pkgs.kakounePlugins.parinfer-rust ]; };
        };
      }
    )
  ];

  home.packages = with pkgs; [ fzf ];
}
