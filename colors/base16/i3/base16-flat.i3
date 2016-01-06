# ~/.i3/config
# i3 config template
# Base16 Flat by Chris Kempson (http://chriskempson.com)
# template by Matt Parnell, @parnmatt

set $base00 #2C3E50
set $base01 #34495E
set $base02 #7F8C8D
set $base03 #95A5A6
set $base04 #BDC3C7
set $base05 #e0e0e0
set $base06 #f5f5f5
set $base07 #ECF0F1
set $base08 #E74C3C
set $base09 #E67E22
set $base0A #F1C40F
set $base0B #2ECC71
set $base0C #1ABC9C
set $base0D #3498DB
set $base0E #9B59B6
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


