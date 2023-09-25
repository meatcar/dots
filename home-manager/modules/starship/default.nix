{ pkgs, ... }: {
  programs.starship.enable = true;
  # xdg.configFile."starship.toml".source = ./starship.toml;
  programs.starship.settings = {
    character = {
      success_symbol = "[\\$](bold green)";
      error_symbol = "[\\$](bold red)";
      vicmd_symbol = "[](bold green)";
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

    aws.symbol = " ";
    buf.symbol = " ";
    c.symbol = " ";
    conda.symbol = "○ ";
    dart.symbol = " ";
    directory.read_only = "󰌾 ";
    docker_context.symbol = " ";
    elixir.symbol = " ";
    elm.symbol = " ";
    fossil_branch.symbol = " ";
    git_branch.symbol = " ";
    golang.symbol = " ";
    guix_shell.symbol = " ";
    haskell.symbol = " ";
    haxe.symbol = " ";
    hg_branch.symbol = " ";
    hostname.ssh_symbol = "󰢹 ";
    java.symbol = " ";
    julia.symbol = " ";
    lua.symbol = " ";
    memory_usage.symbol = "󰍛 ";
    meson.symbol = "󰔷 ";
    nim.symbol = " ";
    nix_shell.symbol = " ";
    nodejs.symbol = "󰎙 ";
    package.symbol = "󰏗 ";
    pijul_channel.symbol = " ";
    php.symbol = " ";
    python.symbol = " ";
    rlang.symbol = "󰟔 ";
    ruby.symbol = " ";
    rust.symbol = " ";
    zig.symbol = "󱐋 ";
  };
}
