function command_exists
  # make sure command is not a windows executable
  set -l fullpath (command -s $argv[1])
  test -n $fullpath && string match -q --invert -r '^/mnt/c' $fullpath
end

# fish_add_path, but reject tool output that isn't an absolute existing dir
# (a failing `npm bin -g` etc. can emit '.', poisoning PATH with the cwd)
function add-tool-path
  string match -q '/*' -- "$argv[1]" && test -d "$argv[1]" && fish_add_path -- $argv[1]
end

function set-fish-user-paths \
  --description "Set fish_user_paths"

  set -eU fish_user_paths

  if [ -d $HOME/bin ]
    fish_add_path ~/bin
  end

  if [ -d $HOME/.local/bin ]
    fish_add_path $HOME/.local/bin
  end

  if command_exists emacs
    fish_add_path $HOME/.emacs.d/bin
  end

  if command_exists yarn
    add-tool-path (yarn global bin)
  end

  if command_exists npm
    add-tool-path (npm bin -g)
  end

  if command_exists bun
    add-tool-path (bun pm bin -g)
  end

  if command_exists go
    set -x GOPATH $HOME/go
    add-tool-path (go env GOROOT)/bin
    add-tool-path (go env GOPATH)/bin
  end

  if test -z "$DOCKER_HOST" -a -n "$XDG_RUNTIME_DIR"
    set -gx DOCKER_HOST "unix://$XDG_RUNTIME_DIR/podman/podman.sock"
  end
end
