{
  pkgs,
  lib,
  inputs,
  ...
}:
let
  starship-jj = inputs.starship-jj.packages.${pkgs.stdenv.system}.default;
in
{
  home.packages = [ starship-jj ];
  programs.starship = {
    enable = true;

    # NOTE: blocked by https://github.com/starship/starship/issues/4929
    # enableTransience = true;

    settings = {
      format = "$username$hostname$directory$fill $shell\${custom.jj}$all$line_break$shlvl$character";
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
        success_symbol = "[\\$ ](bold green)"; # single-width
        error_symbol = "[\\$ ](bold red)"; # single-width
        vicmd_symbol = "[ ](bold green)"; # double-width
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

      shell = {
        disabled = false;
        fish_indicator = lib.mkDefault "fish";
        bash_indicator = lib.mkDefault "bash";
        zsh_indicator = lib.mkDefault "zsh";
        powershell_indicator = lib.mkDefault "pwsh";
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
        format = "via [$symbol( $name)( $state)]($style) ";
        pure_msg = "[ ](bold green)";
        impure_msg = ""; # impure by default
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

      git_status = {
        format = "([($conflicted$stashed )($deleted$renamed$modified$untracked)$staged($ahead_behind)]($style) )";
        stashed = "≡\${count}";
        conflicted = "!\${count}";
        untracked = "?\${count}";
        staged = "✓ \${count}";
        modified = "±\${count}";
        deleted = "-\${count}";
        renamed = "»\${count}";
        ahead = "⇡ \${count}";
        behind = "⇣ \${count}";
        diverged = "⇡ \${ahead_count}⇣ \${behind_count}";
      };

      git_status.disabled = true;
      git_commit.disabled = true;
      git_metrics.disabled = true;
      git_branch.disabled = true;

      custom =
        let
          mkGitCustomModule = name: {
            when = "! jj --ignore-working-copy root";
            command = "starship module ${name}";
            style = ""; # This disables the default "(bold green)" style
            description = "Only show ${name} if we're not in a jj repo";
          };
        in
        {
          git_status = mkGitCustomModule "git_status";
          git_commit = mkGitCustomModule "git_commit";
          git_metrics = mkGitCustomModule "git_metrics";
          git_branch = mkGitCustomModule "git_branch";

          jj = {
            command = "prompt";
            format = "$output";
            ignore_timeout = true;
            shell = [
              "${inputs.starship-jj.packages.${pkgs.stdenv.system}.default}/bin/starship-jj"
              "--ignore-working-copy"
              "--config"
              "git.fetch=[]"
              "starship"
            ];
            use_stdin = false;
            detect_folders = [ ".jj" ];
            #   # for speed
            #   shell = [
            #     "sh"
            #     "--norc"
            #     "--noprofile"
            #   ];
            #   detect_folders = [ ".jj" ];
            #   symbol = "jj ";
            #   command = ''
            #     jj log --revisions @ --no-graph --ignore-working-copy --color always --limit 1 --template '
            #     separate(" ",
            #     change_id.shortest(4),
            #     commit_id.shortest(4),
            #     bookmarks,
            #     "|",
            #     concat(
            #     if(conflict, "💥"),
            #     if(divergent, "🚧"),
            #     if(hidden, "👻"),
            #     if(immutable, "🔒"),
            #     ),
            #     raw_escape_sequence("\x1b[1;32m") ++ if(empty, "\""),
            #     raw_escape_sequence("\x1b[1;32m") ++ coalesce(
            #     concat(
            #     "(",
            #     truncate_end(29, description.first_line(), "…"),
            #     ")"
            #     ),
            #     "∅",
            #     ) ++ raw_escape_sequence("\x1b[0m"),
            #     )
            #     '
            #   '';
          };
        };
    };
  };
  xdg.configFile."starship-jj/starship-jj.toml".text = builtins.readFile ./starship-jj.toml;
}
