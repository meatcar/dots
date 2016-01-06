# ~/.i3/config
# i3 config template
# Base16 Atelier Cave by Bram de Haan (http://atelierbram.github.io/syntax-highlighting/atelier-schemes/cave)
# template by Matt Parnell, @parnmatt

set $base00 #19171c
set $base01 #26232a
set $base02 #585260
set $base03 #655f6d
set $base04 #7e7887
set $base05 #8b8792
set $base06 #e2dfe7
set $base07 #efecf4
set $base08 #be4678
set $base09 #aa573c
set $base0A #a06e3b
set $base0B #2a9292
set $base0C #398bc6
set $base0D #576ddb
set $base0E #955ae7
set $base0F #bf40bf

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


