# ~/.i3/config
# i3 config template
# Base16 Marrakesh by Alexandre Gavioli (http://github.com/Alexx2/)
# template by Matt Parnell, @parnmatt

set $base00 #201602
set $base01 #302e00
set $base02 #5f5b17
set $base03 #6c6823
set $base04 #86813b
set $base05 #948e48
set $base06 #ccc37a
set $base07 #faf0a5
set $base08 #c35359
set $base09 #b36144
set $base0A #a88339
set $base0B #18974e
set $base0C #75a738
set $base0D #477ca1
set $base0E #8868b3
set $base0F #b3588e

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


