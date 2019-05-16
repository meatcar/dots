function addpath 
    set -aU fish_user_paths $argv[1]
end

function set-fish-user-paths \
    --description "Set fish_user_paths"

    set -e fish_user_paths 

    addpath $HOME/.emacs.d/bin # DOOM EMACS

    if [ -d ~/.local/bin ]
        addpath ~/.local/bin
    end

    if command -qs yarn
        addpath (yarn global bin)
    end

    if command -qs npm
        addpath (npm bin -g)
    end

    if command -qs go
        set -x GOPATH $HOME/go
        addpath (go env GOROOT)/bin
        addpath (go env GOPATH)/bin
    end
end

