{
  config,
  pkgs,
  lib,
  specialArgs,
  ...
}: {
  options = let
    inherit (lib) mkOption types;
    theme = {
      alacritty = mkOption {
        description = "Alacritty theme YAML";
        type = types.path;
      };
    };
  in {
    themes = {
      light = theme;
      dark = theme;
    };
    theme = theme;
  };

  config = {
    themes = let
      theme = specialArgs.inputs.alacritty-theme;
    in {
      light.alacritty = "${theme}/themes/pencil_light.yaml";
      dark.alacritty = "${theme}/themes/hyper.yaml";
    };
    theme = config.themes.dark;

    programs.alacritty.enable = true;
    xdg.configFile."alacritty/alacritty.yml".text = ''
      ${builtins.readFile ./alacritty.yml}
      ${builtins.readFile config.theme.alacritty}
    '';
  };
}
