# ~/.i3/config
# i3 config template
# Base16 Grayscale by Alexandre Gavioli (https://github.com/Alexx2/)
# template by Matt Parnell, @parnmatt

set $base00 #101010
set $base01 #252525
set $base02 #464646
set $base03 #525252
set $base04 #ababab
set $base05 #b9b9b9
set $base06 #e3e3e3
set $base07 #f7f7f7
set $base08 #7c7c7c
set $base09 #999999
set $base0A #a0a0a0
set $base0B #8e8e8e
set $base0C #868686
set $base0D #686868
set $base0E #747474
set $base0F #5e5e5e

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


