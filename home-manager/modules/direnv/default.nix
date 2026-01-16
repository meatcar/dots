{
  lib,
  ...
}:
let
  env_store = "~/Sync/backup/dev/env";
in
{
  programs.git.ignores = [ ".direnv/" ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    stdlib = ''
      tmux_session(){
        echo "tmux_session is deprecated and should be removed" >&2
      }

      session_name(){
        echo "session_name is deprecated and should be removed" >&2
      }

      # store .direnv outside project dir
      # source: https://github.com/nix-community/nix-direnv/blob/master/README.md#storing-direnv-outside-the-project-directory
      : ''${XDG_CACHE_HOME:=$HOME/.cache}
      declare -A direnv_layout_dirs
      direnv_layout_dir() {
          echo "''${direnv_layout_dirs[$PWD]:=$(
              echo -n "$XDG_CACHE_HOME"/direnv/layouts/
              echo -n "$PWD" | shasum | cut -d ' ' -f 1
          )}"
      }
    '';
  };

  nix.settings = {
    keep-derivations = true;
    keep-outputs = true;
  };

  home.sessionVariables.ENV_STORE = env_store;

  programs.fish = {
    interactiveShellInit = ''
      # NOTE: must load before direnv hook
      source ${./autotmux.fish}
    '';
    functions = {
      env-store-path = {
        description = "get the store path of the .env file in directory";
        body = ''
          echo "$ENV_STORE"/(systemd-escape -p $PWD/.env)
        '';
      };
      env-link = {
        description = "symlink a .env file from the env store to this directory";
        body = ''
          set -l env_file (env-store-path)
          if ! test -f "$env_file"
            echo "$env_file" not found >&2
            return 1
          end
          echo .env linked to "$env_file" >&2
          ln -s "$env_file" .env
        '';
      };
      env-backup = {
        description = "backup a .env file replacing it with a symlink";
        body = ''
          set -l env_file (env-store-path)
          if test ! -f .env.example
            echo ".env.example not found."
            echo "sanitizing .env, copying to .env.example"
            sed -E 's/=.+$/=/' .env > .env.example
            echo "confirm all env vars needed in .env.example:"
            cat .env.example
          end
          if test ! -f "$env_file"
            echo .env moved to "$env_file" >&2
            mv -i .env "$env_file"
            env-link
          end
        '';
      };
    };
  };
}
