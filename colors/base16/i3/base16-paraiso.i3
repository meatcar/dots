# ~/.i3/config
# i3 config template
# Base16 Paraiso by Jan T. Sott
# template by Matt Parnell, @parnmatt

set $base00 #2f1e2e
set $base01 #41323f
set $base02 #4f424c
set $base03 #776e71
set $base04 #8d8687
set $base05 #a39e9b
set $base06 #b9b6b0
set $base07 #e7e9db
set $base08 #ef6155
set $base09 #f99b15
set $base0A #fec418
set $base0B #48b685
set $base0C #5bc4bf
set $base0D #06b6ef
set $base0E #815ba4
set $base0F #e96ba8

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


