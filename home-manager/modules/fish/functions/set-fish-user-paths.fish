function command_exists
  # make sure command is not a windows executable
  set -l fullpath (command -s $argv[1])
  test -n $fullpath && string match -q --invert -r '^/mnt/c' $fullpath
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
    fish_add_path (yarn global bin)
  end

  if command_exists npm
    fish_add_path (npm bin -g)
  end

  if command_exists bun
    fish_add_path (bun pm bin -g)
  end

  if command_exists go
    set -x GOPATH $HOME/go
    fish_add_path (go env GOROOT)/bin
    fish_add_path (go env GOPATH)/bin
  end
end
