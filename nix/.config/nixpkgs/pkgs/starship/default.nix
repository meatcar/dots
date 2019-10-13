{ pkgs, ... }: {
  programs.starship.enable = true;
  # xdg.configFile."starship.toml".source = ./starship.toml;
  programs.starship.settings = {
    character = {
      symbol = "$";
      vicmd_symbol = ":";
    };

    env_var = {
      variable = "SHELL";
    };
  };
}
