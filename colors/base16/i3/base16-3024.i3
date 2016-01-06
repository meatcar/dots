# ~/.i3/config
# i3 config template
# Base16 3024 by Jan T. Sott (http://github.com/idleberg)
# template by Matt Parnell, @parnmatt

set $base00 #090300
set $base01 #3a3432
set $base02 #4a4543
set $base03 #5c5855
set $base04 #807d7c
set $base05 #a5a2a2
set $base06 #d6d5d4
set $base07 #f7f7f7
set $base08 #db2d20
set $base09 #e8bbd0
set $base0A #fded02
set $base0B #01a252
set $base0C #b5e4f4
set $base0D #01a0e4
set $base0E #a16a94
set $base0F #cdab53

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


