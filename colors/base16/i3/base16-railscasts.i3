# ~/.i3/config
# i3 config template
# Base16 Railscasts by Ryan Bates (http://railscasts.com)
# template by Matt Parnell, @parnmatt

set $base00 #2b2b2b
set $base01 #272935
set $base02 #3a4055
set $base03 #5a647e
set $base04 #d4cfc9
set $base05 #e6e1dc
set $base06 #f4f1ed
set $base07 #f9f7f3
set $base08 #da4939
set $base09 #cc7833
set $base0A #ffc66d
set $base0B #a5c261
set $base0C #519f50
set $base0D #6d9cbe
set $base0E #b6b3eb
set $base0F #bc9458

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


