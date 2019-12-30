{ lib, ... }:
let
  inherit (lib) mkOption types;
  theme = {
    alacritty = mkOption {
      description = "Alacritty theme YAML";
      type = types.path;
    };
  };
in
{
  themes = {
    light = theme;
    dark = theme;
  };
}
