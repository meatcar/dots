# ~/.i3/config
# i3 config template
# Base16 Atelier Plateau by Bram de Haan (http://atelierbram.github.io/syntax-highlighting/atelier-schemes/plateau)
# template by Matt Parnell, @parnmatt

set $base00 #1b1818
set $base01 #292424
set $base02 #585050
set $base03 #655d5d
set $base04 #7e7777
set $base05 #8a8585
set $base06 #e7dfdf
set $base07 #f4ecec
set $base08 #ca4949
set $base09 #b45a3c
set $base0A #a06e3b
set $base0B #4b8b8b
set $base0C #5485b6
set $base0D #7272ca
set $base0E #8464c4
set $base0F #bd5187

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


