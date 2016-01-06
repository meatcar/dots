# ~/.i3/config
# i3 config template
# Base16 Atelier Savanna by Bram de Haan (http://atelierbram.github.io/syntax-highlighting/atelier-schemes/savanna)
# template by Matt Parnell, @parnmatt

set $base00 #171c19
set $base01 #232a25
set $base02 #526057
set $base03 #5f6d64
set $base04 #78877d
set $base05 #87928a
set $base06 #dfe7e2
set $base07 #ecf4ee
set $base08 #b16139
set $base09 #9f713c
set $base0A #a07e3b
set $base0B #489963
set $base0C #1c9aa0
set $base0D #478c90
set $base0E #55859b
set $base0F #867469

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


