# ~/.i3/config
# i3 config template
# Base16 Colors by mrmrs (http://clrs.cc)
# template by Matt Parnell, @parnmatt

set $base00 #111111
set $base01 #333333
set $base02 #555555
set $base03 #777777
set $base04 #999999
set $base05 #bbbbbb
set $base06 #dddddd
set $base07 #ffffff
set $base08 #ff4136
set $base09 #ff851b
set $base0A #ffdc00
set $base0B #2ecc40
set $base0C #7fdbff
set $base0D #0074d9
set $base0E #b10dc9
set $base0F #85144b

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


