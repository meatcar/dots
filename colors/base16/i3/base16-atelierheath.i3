# ~/.i3/config
# i3 config template
# Base16 Atelier Heath by Bram de Haan (http://atelierbram.github.io/syntax-highlighting/atelier-schemes/heath)
# template by Matt Parnell, @parnmatt

set $base00 #1b181b
set $base01 #292329
set $base02 #695d69
set $base03 #776977
set $base04 #9e8f9e
set $base05 #ab9bab
set $base06 #d8cad8
set $base07 #f7f3f7
set $base08 #ca402b
set $base09 #a65926
set $base0A #bb8a35
set $base0B #918b3b
set $base0C #159393
set $base0D #516aec
set $base0E #7b59c0
set $base0F #cc33cc

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


