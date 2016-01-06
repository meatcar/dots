# ~/.i3/config
# i3 config template
# Base16 Macintosh by Rebecca Bettencourt (http://www.kreativekorp.com)
# template by Matt Parnell, @parnmatt

set $base00 #000000
set $base01 #404040
set $base02 #404040
set $base03 #808080
set $base04 #808080
set $base05 #c0c0c0
set $base06 #c0c0c0
set $base07 #ffffff
set $base08 #dd0907
set $base09 #ff6403
set $base0A #fbf305
set $base0B #1fb714
set $base0C #02abea
set $base0D #0000d3
set $base0E #4700a5
set $base0F #90713a

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


