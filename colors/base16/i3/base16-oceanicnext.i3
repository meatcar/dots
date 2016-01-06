# ~/.i3/config
# i3 config template
# Base16 OceanicNext by https://github.com/voronianski/oceanic-next-color-scheme
# template by Matt Parnell, @parnmatt

set $base00 #1B2B34
set $base01 #343D46
set $base02 #4F5B66
set $base03 #65737E
set $base04 #A7ADBA
set $base05 #C0C5CE
set $base06 #CDD3DE
set $base07 #D8DEE9
set $base08 #EC5f67
set $base09 #F99157
set $base0A #FAC863
set $base0B #99C794
set $base0C #5FB3B3
set $base0D #6699CC
set $base0E #C594C5
set $base0F #AB7967

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


