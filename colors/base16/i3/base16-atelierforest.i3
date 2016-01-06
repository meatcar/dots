# ~/.i3/config
# i3 config template
# Base16 Atelier Forest by Bram de Haan (http://atelierbram.github.io/syntax-highlighting/atelier-schemes/forest)
# template by Matt Parnell, @parnmatt

set $base00 #1b1918
set $base01 #2c2421
set $base02 #68615e
set $base03 #766e6b
set $base04 #9c9491
set $base05 #a8a19f
set $base06 #e6e2e0
set $base07 #f1efee
set $base08 #f22c40
set $base09 #df5320
set $base0A #c38418
set $base0B #7b9726
set $base0C #3d97b8
set $base0D #407ee7
set $base0E #6666ea
set $base0F #c33ff3

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


