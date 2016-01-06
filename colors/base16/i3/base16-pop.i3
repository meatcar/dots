# ~/.i3/config
# i3 config template
# Base16 Pop by Chris Kempson (http://chriskempson.com)
# template by Matt Parnell, @parnmatt

set $base00 #000000
set $base01 #202020
set $base02 #303030
set $base03 #505050
set $base04 #b0b0b0
set $base05 #d0d0d0
set $base06 #e0e0e0
set $base07 #ffffff
set $base08 #eb008a
set $base09 #f29333
set $base0A #f8ca12
set $base0B #37b349
set $base0C #00aabb
set $base0D #0e5a94
set $base0E #b31e8d
set $base0F #7a2d00

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


