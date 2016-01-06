# ~/.i3/config
# i3 config template
# Base16 Mocha by Chris Kempson (http://chriskempson.com)
# template by Matt Parnell, @parnmatt

set $base00 #3B3228
set $base01 #534636
set $base02 #645240
set $base03 #7e705a
set $base04 #b8afad
set $base05 #d0c8c6
set $base06 #e9e1dd
set $base07 #f5eeeb
set $base08 #cb6077
set $base09 #d28b71
set $base0A #f4bc87
set $base0B #beb55b
set $base0C #7bbda4
set $base0D #8ab3b5
set $base0E #a89bb9
set $base0F #bb9584

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


