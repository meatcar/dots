# ~/.i3/config
# i3 config template
# Base16 Atelier Lakeside by Bram de Haan (http://atelierbram.github.io/syntax-highlighting/atelier-schemes/lakeside/)
# template by Matt Parnell, @parnmatt

set $base00 #161b1d
set $base01 #1f292e
set $base02 #516d7b
set $base03 #5a7b8c
set $base04 #7195a8
set $base05 #7ea2b4
set $base06 #c1e4f6
set $base07 #ebf8ff
set $base08 #d22d72
set $base09 #935c25
set $base0A #8a8a0f
set $base0B #568c3b
set $base0C #2d8f6f
set $base0D #257fad
set $base0E #6b6bb8
set $base0F #b72dd2

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


