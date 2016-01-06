# ~/.i3/config
# i3 config template
# Base16 Bright by Chris Kempson (http://chriskempson.com)
# template by Matt Parnell, @parnmatt

set $base00 #000000
set $base01 #303030
set $base02 #505050
set $base03 #b0b0b0
set $base04 #d0d0d0
set $base05 #e0e0e0
set $base06 #f5f5f5
set $base07 #ffffff
set $base08 #fb0120
set $base09 #fc6d24
set $base0A #fda331
set $base0B #a1c659
set $base0C #76c7b7
set $base0D #6fb3d2
set $base0E #d381c3
set $base0F #be643c

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


