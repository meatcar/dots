{
  config,
  lib,
  pkgs,
  nixpkgs-unstable,
  ...
}:
{
  imports = [ ./jjui.nix ];
  home.packages =
    (with nixpkgs-unstable; [
      lazyjj
    ])
    ++ (with pkgs; [
      watchman
      meld
    ]);
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
              "JJ: Format: <type>(<scope>): <description>\n",
              "JJ: Types: feat, fix, docs, style, refactor, perf, test, chore, revert, build, ci\n",
              "JJ: Scope: optional, kebab-case, nested with /, e.g. (auth), (api/token)\n",
              coalesce(description, default_commit_description, "\n"),
              "\n",
              surround(
                "\nJJ: This commit contains the following changes:\n", "",
                indent("JJ:     ", diff.stat(72)),
              ),
              "\nJJ: ignore-rest\n",
              diff.git(),
            )
          '';
          new_commit_description = ''
            if(parents.len() > 1,
              "Merge " ++ parents.skip(1).map(|p| if(
                p.bookmarks(),
                p.bookmarks().first().name(),
                p.change_id().shortest(8)
              )).join(", ") ++ " into " ++ if(
                parents.first().bookmarks(),
                parents.first().bookmarks().first().name(),
                parents.first().change_id().shortest(8)
              ) ++ "\n",
              ""
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

          # source: https://isaaccorbrey.com/notes/jujutsu-megamerges-for-fun-and-profit
          # `jj stack <revset>` to include specific revs
          stack = [
            "rebase"
            "--after"
            "trunk()"
            "--before"
            "closest_merge(@)"
            "--revisions"
          ];
          # `jj stage` to include the whole stack after the megamerge
          stage = [
            "stack"
            "closest_merge(@)+:: ~ empty()"
          ];

          # source: https://github.com/thoughtpolice/a/blob/2f768e1b0407bc63d6dd01097ff1c5210e48d8f6/tilde/aseipp/dotfiles/jj/config.toml#L98-L104
          # via: https://isaaccorbrey.com/notes/jujutsu-megamerges-for-fun-and-profit
          restack = [
            "rebase"
            "--onto"
            "trunk()"
            "--source"
            "roots(trunk()..) & stack()"
            "--simplify-parents"
          ];
        };
        revset-aliases = {
          # Last Common Commit
          "closest_bookmark(to)" = "heads(::to & bookmarks())";
          "closest_pushable(to)" = "heads(::to & mutable() & ~description(exact:'') & (~empty() | merges()))";
          # jjflow
          "unmerged()" = "bookmarks() & ~::dev()";
          "unpublished()" = "bookmarks() & ~::trunk()";
          "private()" = "description(glob:'private*') | description(glob:'wip*')";
          "work()" = "::@ description('') & private()) & ~bookmarks()";

          # source: https://isaaccorbrey.com/notes/jujutsu-megamerges-for-fun-and-profit
          "closest_merge(to)" = "heads(::to & merges())";

          # source: https://github.com/thoughtpolice/a/blob/2f768e1b0407bc63d6dd01097ff1c5210e48d8f6/tilde/aseipp/dotfiles/jj/config.toml#L98-L104
          # via: https://isaaccorbrey.com/notes/jujutsu-megamerges-for-fun-and-profit
          "stack()" = "stack(@)";
          "stack(x)" = "stack(x, 2)";
          "stack(x, n)" = "ancestors(reachable(x, mutable()), n)";
        };

        # use watchman to auto-snapshot, no need to re-run jj
        # source: https://github.com/yum0e/kekkai?tab=readme-ov-file#watchman-setup
        fsmonitor.backend = "watchman";
        fsmonitor.watchman.register-snapshot-trigger = true;
        snapshot.auto-update-stale = true;

        git = {
          colocate = true;
          write-change-id-header = true;
          fetch = [ "glob:*" ];
          private-commits = "private()";
        };
        remotes.origin.auto-track-bookmarks = "*";
        fix.tools = {
          "50_treefmt" = {
            command = [
              "treefmt"
              "--no-cache"
              "--stdin"
              "$path"
            ];
            patterns = [ "glob:'**/*'" ];
          };
        };
        merge.hunk-level = "word";
        merge-tools =
          let
            # source: https://github.com/jj-vcs/jj/wiki/Vim,-Neovim#using-neovim-as-a-diff-editor-with-existing-git-tooling
            nativeWrapper = tool: rec {
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
            weave = {
              program = "${lib.getExe' pkgs.weave-merge "weave-driver"}";
              merge-args = [
                "$base"
                "$left"
                "$right"
                "-o"
                "$output"
                "-l"
                "$marker_length"
                "-p"
                "$path"
              ];
              merge-conflict-exit-codes = [ 1 ];
              merge-tool-edits-conflict-markers = true;
              conflict-marker-style = "git";
            };
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
          merge-editor = "weave";
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
