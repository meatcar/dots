# ~/.i3/config
# i3 config template
# Base16 Green Screen by Chris Kempson (http://chriskempson.com)
# template by Matt Parnell, @parnmatt

set $base00 #001100
set $base01 #003300
set $base02 #005500
set $base03 #007700
set $base04 #009900
set $base05 #00bb00
set $base06 #00dd00
set $base07 #00ff00
set $base08 #007700
set $base09 #009900
set $base0A #007700
set $base0B #00bb00
set $base0C #005500
set $base0D #009900
set $base0E #00bb00
set $base0F #005500

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


