# ~/.i3/config
# i3 config template
# Base16 Eighties by Chris Kempson (http://chriskempson.com)
# template by Matt Parnell, @parnmatt

set $base00 #2d2d2d
set $base01 #393939
set $base02 #515151
set $base03 #747369
set $base04 #a09f93
set $base05 #d3d0c8
set $base06 #e8e6df
set $base07 #f2f0ec
set $base08 #f2777a
set $base09 #f99157
set $base0A #ffcc66
set $base0B #99cc99
set $base0C #66cccc
set $base0D #6699cc
set $base0E #cc99cc
set $base0F #d27b53

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


