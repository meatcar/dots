# ~/.i3/config
# i3 config template
# Base16 Default by Chris Kempson (http://chriskempson.com)
# template by Matt Parnell, @parnmatt

set $base00 #181818
set $base01 #282828
set $base02 #383838
set $base03 #585858
set $base04 #b8b8b8
set $base05 #d8d8d8
set $base06 #e8e8e8
set $base07 #f8f8f8
set $base08 #ab4642
set $base09 #dc9656
set $base0A #f7ca88
set $base0B #a1b56c
set $base0C #86c1b9
set $base0D #7cafc2
set $base0E #ba8baf
set $base0F #a16946

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


