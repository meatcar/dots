# ~/.i3/config
# i3 config template
# Base16 Atelier Seaside by Bram de Haan (http://atelierbram.github.io/syntax-highlighting/atelier-schemes/seaside/)
# template by Matt Parnell, @parnmatt

set $base00 #131513
set $base01 #242924
set $base02 #5e6e5e
set $base03 #687d68
set $base04 #809980
set $base05 #8ca68c
set $base06 #cfe8cf
set $base07 #f4fbf4
set $base08 #e6193c
set $base09 #87711d
set $base0A #98981b
set $base0B #29a329
set $base0C #1999b3
set $base0D #3d62f5
set $base0E #ad2bee
set $base0F #e619c3

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


