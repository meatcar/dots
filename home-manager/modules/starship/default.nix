{ pkgs, ... }: {
  programs.starship = {
    enable = true;

    # NOTE: blocked by https://github.com/starship/starship/issues/4929
    # enableTransience = true;

    settings = {
      format = "$username$hostname$directory$fill $shell$all$line_break$shlvl$character";
      right_format = "$cmd_duration$status";

      time.disabled = false;
      cmd_duration.show_notifications = true;

      fill = {
        symbol = "─";
        style = "dimmed black";
      };

      username.format = "[$user]($style) ";

      hostname.style = "bold green";
      hostname.format = "in [$ssh_symbol $hostname]($style) ";

      character = {
        format = "$symbol";
        success_symbol = "[\\$ ](bold green)"; #single-width
        error_symbol = "[\\$ ](bold red)"; #single-width
        vicmd_symbol = "[ ](bold green)"; #double-width
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

      directory = {
        fish_style_pwd_dir_length = 1;
        truncation_symbol = "… /";
        before_repo_root_style = "bold cyan";
        repo_root_style = "bold green";
        style = "green"; # after repo root
        # NOTE: can't use truncation, due to https://github.com/starship/starship/issues/3975
        truncation_length = 0;
      };

      battery = {
        full_symbol = "";
        charging_symbol = "";
        discharging_symbol = "";
      };

      git_status = {
        format = "([$conflicted$stashed$deleted$renamed$modified$untracked( $staged)( $ahead_behind)]($style) )";
        conflicted = "!\${count}";
        untracked = "?\${count}";
        staged = "^\${count}";
        modified = "±\${count}";
        deleted = "-\${count}";
        renamed = "»\${count}";
        ahead = "⇡ \${count}";
        behind = "⇣ \${count}";
        diverged = "⇡ \${ahead_count}⇣ \${behind_count}";
      };

      shell = {
        disabled = false;
        fish_indicator = "fish";
        bash_indicator = "bash";
        zsh_indicator = "zsh";
        powershell_indicator = "pwsh";
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

      nix_shell = {
        format = "via [$symbol$state( $name)]($style) ";
        impure_msg = "";
        pure_msg = "";
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
  };
}
