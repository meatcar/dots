function addpath
    set -aU fish_user_paths $argv[1]
end

function command_exists
    # make sure command is not a windows executable
    set -l fullpath (command -s $argv[1])
    test -n $fullpath && string match -q -r '^/mnt/c' $fullpath
end

function set-fish-user-paths \
    --description "Set fish_user_paths"

    set -eU fish_user_paths

    if [ -d $HOME/bin ]
        addpath ~/bin
    end

    if command_exists emacs
        addpath $HOME/.emacs.d/bin
    end

    if [ -d $HOME/.local/bin ]
        addpath $HOME/.local/bin
    end

    if command_exists yarn
        addpath (yarn global bin)
    end

    if command_exists npm
        addpath (npm bin -g)
    end

    if command_exists go
        set -x GOPATH $HOME/go
        addpath (go env GOROOT)/bin
        addpath (go env GOPATH)/bin
    end
end

