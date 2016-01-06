# ~/.i3/config
# i3 config template
# Base16 London Tube by Jan T. Sott
# template by Matt Parnell, @parnmatt

set $base00 #231f20
set $base01 #1c3f95
set $base02 #5a5758
set $base03 #737171
set $base04 #959ca1
set $base05 #d9d8d8
set $base06 #e7e7e8
set $base07 #ffffff
set $base08 #ee2e24
set $base09 #f386a1
set $base0A #ffd204
set $base0B #00853e
set $base0C #85cebc
set $base0D #009ddc
set $base0E #98005d
set $base0F #b06110

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


