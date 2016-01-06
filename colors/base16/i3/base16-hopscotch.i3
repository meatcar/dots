# ~/.i3/config
# i3 config template
# Base16 Hopscotch by Jan T. Sott
# template by Matt Parnell, @parnmatt

set $base00 #322931
set $base01 #433b42
set $base02 #5c545b
set $base03 #797379
set $base04 #989498
set $base05 #b9b5b8
set $base06 #d5d3d5
set $base07 #ffffff
set $base08 #dd464c
set $base09 #fd8b19
set $base0A #fdcc59
set $base0B #8fc13e
set $base0C #149b93
set $base0D #1290bf
set $base0E #c85e7c
set $base0F #b33508

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


