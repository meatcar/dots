# ~/.i3/config
# i3 config template
# Base16 Summerfruit by Christopher Corley (http://cscorley.github.io/)
# template by Matt Parnell, @parnmatt

set $base00 #151515
set $base01 #202020
set $base02 #303030
set $base03 #505050
set $base04 #B0B0B0
set $base05 #D0D0D0
set $base06 #E0E0E0
set $base07 #FFFFFF
set $base08 #FF0086
set $base09 #FD8900
set $base0A #ABA800
set $base0B #00C918
set $base0C #1faaaa
set $base0D #3777E6
set $base0E #AD00A1
set $base0F #cc6633

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


