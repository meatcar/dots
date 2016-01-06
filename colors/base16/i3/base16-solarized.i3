# ~/.i3/config
# i3 config template
# Base16 Solarized by Ethan Schoonover (http://ethanschoonover.com/solarized)
# template by Matt Parnell, @parnmatt

set $base00 #002b36
set $base01 #073642
set $base02 #586e75
set $base03 #657b83
set $base04 #839496
set $base05 #93a1a1
set $base06 #eee8d5
set $base07 #fdf6e3
set $base08 #dc322f
set $base09 #cb4b16
set $base0A #b58900
set $base0B #859900
set $base0C #2aa198
set $base0D #268bd2
set $base0E #6c71c4
set $base0F #d33682

client.focused $base0D $base0D $base00 $base01
client.focused_inactive $base02 $base02 $base03 $base01
client.unfocused $base01 $base01 $base03 $base01
client.urgent $base02 $base08 $base07 $base08

## remember to add the rest of your configuration

bar {
    ## remember to add your favourite status bar, i.e.,
    # status_command i3status
    
        colors {
        separator $base03
        background $base01
        statusline $base05
        focused_workspace $base0C $base0D $base00
        active_workspace $base02 $base02 $base07
        inactive_workspace $base01 $base01 $base03
        urgent_workspace $base08 $base08 $base07
    }
}


