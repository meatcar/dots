# ~/.i3/config
# i3 config template
# Base16 Atelier Dune by Bram de Haan (http://atelierbram.github.io/syntax-highlighting/atelier-schemes/dune)
# template by Matt Parnell, @parnmatt

set $base00 #20201d
set $base01 #292824
set $base02 #6e6b5e
set $base03 #7d7a68
set $base04 #999580
set $base05 #a6a28c
set $base06 #e8e4cf
set $base07 #fefbec
set $base08 #d73737
set $base09 #b65611
set $base0A #ae9513
set $base0B #60ac39
set $base0C #1fad83
set $base0D #6684e1
set $base0E #b854d4
set $base0F #d43552

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


