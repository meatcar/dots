# ~/.i3/config
# i3 config template
# Base16 Monokai by Wimer Hazenberg (http://www.monokai.nl)
# template by Matt Parnell, @parnmatt

set $base00 #272822
set $base01 #383830
set $base02 #49483e
set $base03 #75715e
set $base04 #a59f85
set $base05 #f8f8f2
set $base06 #f5f4f1
set $base07 #f9f8f5
set $base08 #f92672
set $base09 #fd971f
set $base0A #f4bf75
set $base0B #a6e22e
set $base0C #a1efe4
set $base0D #66d9ef
set $base0E #ae81ff
set $base0F #cc6633

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


