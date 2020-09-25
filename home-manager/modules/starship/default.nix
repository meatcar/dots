{ pkgs, ... }: {
  programs.starship.enable = true;
  # xdg.configFile."starship.toml".source = ./starship.toml;
  programs.starship.settings = {
    character = {
      symbol = "$";
      vicmd_symbol = ":";
    };

    env_var = {
      variable = "STARSHIP_SHELL";
    };

    battery = {
      full_symbol = "";
      charging_symbol = "";
      discharging_symbol = "";
    };
    aws.symbol = " ";
    conda.symbol = " ";
    docker.symbol = " ";
    elixir.symbol = " ";
    elm.symbol = " ";
    git_branch.symbol = " ";
    golang.symbol = " ";
    haskell.symbol = " ";
    hg_branch.symbol = " ";
    java.symbol = " ";
    julia.symbol = " ";
    memory_usage.symbol = " ";
    nim.symbol = " ";
    nix_shell.symbol = " ";
    nodejs.symbol = " ";
    package.symbol = " ";
    php.symbol = " ";
    python.symbol = " ";
    ruby.symbol = " ";
    rust.symbol = " ";
  };
}
