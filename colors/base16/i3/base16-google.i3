# ~/.i3/config
# i3 config template
# Base16 Google by Seth Wright (http://sethawright.com)
# template by Matt Parnell, @parnmatt

set $base00 #1d1f21
set $base01 #282a2e
set $base02 #373b41
set $base03 #969896
set $base04 #b4b7b4
set $base05 #c5c8c6
set $base06 #e0e0e0
set $base07 #ffffff
set $base08 #CC342B
set $base09 #F96A38
set $base0A #FBA922
set $base0B #198844
set $base0C #3971ED
set $base0D #3971ED
set $base0E #A36AC7
set $base0F #3971ED

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


