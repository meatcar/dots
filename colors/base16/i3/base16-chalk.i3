# ~/.i3/config
# i3 config template
# Base16 Chalk by Chris Kempson (http://chriskempson.com)
# template by Matt Parnell, @parnmatt

set $base00 #151515
set $base01 #202020
set $base02 #303030
set $base03 #505050
set $base04 #b0b0b0
set $base05 #d0d0d0
set $base06 #e0e0e0
set $base07 #f5f5f5
set $base08 #fb9fb1
set $base09 #eda987
set $base0A #ddb26f
set $base0B #acc267
set $base0C #12cfc0
set $base0D #6fc2ef
set $base0E #e1a3ee
set $base0F #deaf8f

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


