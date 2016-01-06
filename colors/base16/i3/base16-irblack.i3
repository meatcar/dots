# ~/.i3/config
# i3 config template
# Base16 IR Black by Timothée Poisot (http://timotheepoisot.fr)
# template by Matt Parnell, @parnmatt

set $base00 #000000
set $base01 #242422
set $base02 #484844
set $base03 #6c6c66
set $base04 #918f88
set $base05 #b5b3aa
set $base06 #d9d7cc
set $base07 #fdfbee
set $base08 #ff6c60
set $base09 #e9c062
set $base0A #ffffb6
set $base0B #a8ff60
set $base0C #c6c5fe
set $base0D #96cbfe
set $base0E #ff73fd
set $base0F #b18a3d

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


