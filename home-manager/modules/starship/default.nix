{ pkgs, ... }: {
  programs.starship.enable = true;
  # xdg.configFile."starship.toml".source = ./starship.toml;
  programs.starship.settings = {
    character = {
      success_symbol = "[\\$](bold green)";
      error_symbol = "[\\$](bold red)";
      vicmd_symbol = "[](bold green)";
    };

    status = {
      disabled = false;
      symbol = "!";
    };

    env_var = {
      variable = "STARSHIP_SHELL";
    };

    battery = {
      full_symbol = "";
      charging_symbol = "";
      discharging_symbol = "";
    };

    git_status = {
      staged = "+\${count}";
      modified = "!\${count}";
      ahead = "⇡\${count}";
      diverged = "⇕⇡\${ahead_count}⇣\${behind_count}";
      behind = "⇣\${count}";
    };

    aws.symbol = " ";
    conda.symbol = " ";
    docker_context.symbol = " ";
    elixir.symbol = " ";
    elm.symbol = " ";
    git_branch.symbol = " ";
    golang.symbol = " ";
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
    zig.symbol = " ";
  };
}
