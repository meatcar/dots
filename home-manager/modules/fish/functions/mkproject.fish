function evalcommit --description "Run command and commit with command as message"
  set -l cmd (string join " " $argv)
  eval $cmd
  jj commit -m "$cmd"
end

function mkproject --description 'Create a new dev project structure, or convert existing one.'
  # current dir status
  set -l is_git (git rev-parse --is-inside-work-tree 2>/dev/null)
  if test "$is_git" = "true"
    # rename currend dir to $dirname-default
    set -l dirname (basename "$PWD")
    cd ..
    mv "$dirname" "$dirname-default"
    mkdir "$dirname"
    mv "$dirname-default" "$dirname"/
    cd "$dirname/$dirname-default"
  else
    set -l dirname "$argv[1]"
    mkdir -p "$dirname/$dirname-default"
    cd "$dirname/$dirname-default"
    jj git init
    jj commit -m "Initial commit"
    evalcommit nix flake init -t github:meatcar/flake-templates#default
    direnv allow .
  end
end
