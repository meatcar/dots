# Defined in /home/meatcar/.config/fish/functions/fishify.fish @ line 1
function fishify --description 'Convert an env file into a fish-friendly format. First arg is passed through to set'
	if [ (count $argv) -gt 0 ]
        set arg (string match -r -- '^-.*$' $argv[1])
        set -e argv[1]
    end
    sed '/^_=/d' \
        | sed '/^PWD=/d' \
        | sed '/^SHLVL=/d' \
        | sed -E (echo "s/^[ \t]*([^#][^=]+)=(.+\$)/set $arg \1 \2/") $argv
end
