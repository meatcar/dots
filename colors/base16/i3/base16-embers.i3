# ~/.i3/config
# i3 config template
# Base16 Embers by Jannik Siebert (https://github.com/janniks)
# template by Matt Parnell, @parnmatt

set $base00 #16130F
set $base01 #2C2620
set $base02 #433B32
set $base03 #5A5047
set $base04 #8A8075
set $base05 #A39A90
set $base06 #BEB6AE
set $base07 #DBD6D1
set $base08 #826D57
set $base09 #828257
set $base0A #6D8257
set $base0B #57826D
set $base0C #576D82
set $base0D #6D5782
set $base0E #82576D
set $base0F #825757

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


