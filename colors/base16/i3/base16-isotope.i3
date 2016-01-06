# ~/.i3/config
# i3 config template
# Base16 Isotope by Jan T. Sott
# template by Matt Parnell, @parnmatt

set $base00 #000000
set $base01 #404040
set $base02 #606060
set $base03 #808080
set $base04 #c0c0c0
set $base05 #d0d0d0
set $base06 #e0e0e0
set $base07 #ffffff
set $base08 #ff0000
set $base09 #ff9900
set $base0A #ff0099
set $base0B #33ff00
set $base0C #00ffff
set $base0D #0066ff
set $base0E #cc00ff
set $base0F #3300ff

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


