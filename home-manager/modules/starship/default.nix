{ pkgs, ... }: {
  programs.starship.enable = true;
  # xdg.configFile."starship.toml".source = ./starship.toml;
  programs.starship.settings = {
    format = "$username$hostname$directory$fill $shell$all$line_break$shlvl$character";
    right_format = "$cmd_duration$status";
    time.disabled = false;
    cmd_duration.show_notifications = true;

    fill = {
      symbol = "─";
      style = "dimmed black";
    };

    nix_shell = {
      format = "via [$symbol$state( $name)]($style) ";
      impure_msg = "";
      pure_msg = "";
    };

    character = {
      success_symbol = "[\\$](bold green)";
      error_symbol = "[\\$](bold red)";
      vicmd_symbol = "[](bold green)";
    };

    status = {
      disabled = false;
      format = "[$symbol$common_meaning$signal_name$maybe_int]($style) ";
      success_symbol = "";
      symbol = "  ";
      not_executable_symbol = "  ";
      not_found_symbol = "  ";
      sigint_symbol = "  ";
      signal_symbol = "!";
      map_symbol = true;
      pipestatus = true;
      pipestatus_format = "\[$pipestatus\] => [$symbol$common_meaning$signal_name$maybe_int]($style)";
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

    shell = {
      disabled = false;
      # fish_indicator = "󰈺 ";
      # bash_indicator = "b$_";
      # zsh_indicator = "zs";
      # powershell_indicator = " ";
    };
    shlvl = {
      disabled = false;
      format = "[$symbol]($style)";
      style = "dimmed black";
      repeat = true;
      symbol = "\\$";
      repeat_offset = 1;
      threshold = 0;
    };

    username.format = "[$user]($style) ";
    hostname.format = "in $ssh_symbol[$hostname]($style) ";
    directory.format = "in [$path]($style)[$read_only]($read_only_style) ";

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
