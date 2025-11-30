{
  config,
  lib,
  pkgs,
  nixpkgs-unstable,
  ...
}:
{
  imports = [ ./jjui.nix ];
  home.packages = with nixpkgs-unstable; [
    lazyjj
  ];
  programs.jujutsu =
    let
      delta = "${lib.getExe config.programs.delta.package}";
      deltaArgs = [
        # trim file paths to just the filename relative to the repo
        "--file-transformation"
        "s;^.*/jj-diff-[^/]*/[^/]*/;;"
      ];

    in
    {
      enable = true;
      package = nixpkgs-unstable.jujutsu;
      settings = {
        user = {
          name = "Denys Pavlov";
          email = "github@denys.me";
        };
        signing = {
          behavior = "drop";
          backend = "ssh";
          key = config.programs.git.settings.user.signingKey;
          backends.ssh = {
            program = "${lib.getExe' pkgs._1password-gui "op-ssh-sign"}";
          };
        };
        git.sign-on-push = true;
        # Settings from https://oppi.li/posts/configuring_jujutsu/
        template-aliases = {
          "format_timestamp(timestamp)" = "timestamp.ago()";
          "format_short_id(id)" = "id.shortest(4)";
        };
        templates = {
          git_push_bookmark = ''
            "meatcar/push-" ++ change_id.short()
          '';
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
              "JJ: A short and descriptive commit message following conventional commits:\n",
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
          colocate = true;
          write-change-id-header = true;
          fetch = [ "glob:*" ];
          private-commits = "description(glob:'wip:*') | description(glob:'private:*')";
        };
        fix.tools = {
          treefmt = {
            program = "treefmt";
          };
        };
        merge-tools =
          let
            # source: https://github.com/jj-vcs/jj/wiki/Vim,-Neovim#using-neovim-as-a-diff-editor-with-existing-git-tooling
            nativeWrapper = tool: {
              program = "sh";
              edit-args = [
                "-c"
                ''
                  set -eu
                  rm -f "$right/JJ-INSTRUCTIONS"
                  git -C "$left" init -q
                  git -C "$left" add -A
                  git -C "$left" commit -q -m baseline --allow-empty # create parent commit
                  mv "$left/.git" "$right"
                  git -C "$right" add --intent-to-add -A # create current working copy
                  (cd "$right"; ${tool})
                  git -C "$right" diff-index --quiet --cached HEAD && { echo "No changes done, aborting split."; exit 1; }
                  git -C "$right" commit -q -m split # create commit on top of parent including changes
                  git -C "$right" restore . # undo changes in modified files
                  git -C "$right" reset .   # undo --intent-to-add
                  git -C "$right" clean -q -df # remove untracked files
                ''
              ];
            };
          in
          {
            nvim = nativeWrapper "nvim";
            nvim-neogit = nativeWrapper ''nvim -c "lua require('lazy').load({plugins = {'neogit'}})" -c Neogit'';
            lazygit = nativeWrapper "lazygit --screen-mode half";
            gitu = nativeWrapper "gitu";
            delta = {
              program = delta;
              diff-expected-exit-codes = [
                0
                1
              ];
              diff-args = deltaArgs ++ [
                "$left"
                "$right"
              ];
            };
          };
        ui = {
          default-command = "status";
          diff-editor = "lazygit";
          diff-formatter = "delta";
          pager = [
            delta
            # apparently jj calls less with -X, pass it through
            "--pager"
            "less -FRX"
          ]
          ++ deltaArgs;
        };
        "--scope" = [
          {
            "--when".repositories = [ "/git/hub/alipes" ];
            user.email = "denysp@alipes.com";
          }
        ];
      };
    };
}
