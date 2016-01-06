# ~/.i3/config
# i3 config template
# Base16 Atelier Estuary by Bram de Haan (http://atelierbram.github.io/syntax-highlighting/atelier-schemes/estuary)
# template by Matt Parnell, @parnmatt

set $base00 #22221b
set $base01 #302f27
set $base02 #5f5e4e
set $base03 #6c6b5a
set $base04 #878573
set $base05 #929181
set $base06 #e7e6df
set $base07 #f4f3ec
set $base08 #ba6236
set $base09 #ae7313
set $base0A #a5980d
set $base0B #7d9726
set $base0C #5b9d48
set $base0D #36a166
set $base0E #5f9182
set $base0F #9d6c7c

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


