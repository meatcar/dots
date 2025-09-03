{ pkgs, ... }:
{
  home.packages = with pkgs; [
    jjui
    lazyjj
  ];
  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        name = "Denys Pavlov";
        email = "github@denys.me";
      };
      # Settings from https://oppi.li/posts/configuring_jujutsu/
      template-aliases = {
        "format_timestamp(timestamp)" = "timestamp.ago()";
      };
      templates = {
        log_node = ''
          label("node",
            coalesce(
              if(!self, label("elided", "~")),
              if(current_working_copy, label("working_copy", "@")),
              if(conflict, label("conflict", "×")),
              if(immutable, label("immutable", "*")),
              label("normal", "·")
            )
          )
        '';
        draft_commit_description = ''
          concat(
            coalesce(description, default_commit_description, "\n"),
            surround(
              "\nJJ: This commit contains the following changes:\n", "",
              indent("JJ:     ", diff.stat(72)),
            ),
            "\nJJ: ignore-rest\n",
            diff.git(),
          )
        '';
        short_log = ''
          if(root,
            format_root_commit(self),
            label(if(current_working_copy, "working_copy"),
              concat(
                separate(" ",
                  format_short_change_id_with_hidden_and_divergent_info(self),
                  format_short_commit_id(commit_id),
                  if(empty, label("empty", "(empty)")),
                  if(description,
                    description.first_line(),
                    label(if(empty, "empty"), description_placeholder),
                  ),
                  bookmarks,
                  tags,
                  working_copies,
                  if(git_head, label("git_head", "HEAD")),
                  if(conflict, label("conflict", "conflict")),
                  if(config("ui.show-cryptographic-signatures").as_boolean(),
                    format_short_cryptographic_signature(signature)),
                ) ++ "\n",
              ),
            )
          )
        '';
      };
      aliases = {
        # source: https://github.com/jj-vcs/jj/discussions/5568#discussioncomment-13034102
        tug = [
          "util"
          "exec"
          "--"
          "sh"
          "-c"
          ''
            if [ -z "$1" ]; then
              jj bookmark move --from "closest_bookmark(@)" --to "closest_pushable(@)"
            else
              jj bookmark move --to "closest_pushable(@)" "$@"
            fi
          ''
          ""
        ];
        l = [
          "log"
          "-Tbuiltin_log_oneline"
        ];
      };
      revset-aliases = {
        # Last Common Commit
        "closest_bookmark(to)" = "heads(::to & bookmarks())";
        "closest_pushable(to)" = "heads(::to & mutable() & ~description(exact:'') & (~empty() | merges()))";
      };
      git = {
        write-change-id-header = true;
      };
      ui = {
        default_command = "status";
        diff-formatter = ":git";
        pager = [
          "delta"
          "--pager"
          "less -FRX"
        ];
      };
      diff = {
        tool = "delta";
      };
      "--scope" = [
        {
          "--when.commands" = [
            "diff"
            "show"
          ];
          "ui.pager" = "delta";
          "ui.diff.format" = "git";
        }
        {
          "--when.repositories" = [ "/git/hub/alipes" ];
          "user.email" = "denysp@alipes.com";
        }
      ];
    };
  };
}
