# ~/.i3/config
# i3 config template
# Base16 Bespin by Jan T. Sott
# template by Matt Parnell, @parnmatt

set $base00 #28211c
set $base01 #36312e
set $base02 #5e5d5c
set $base03 #666666
set $base04 #797977
set $base05 #8a8986
set $base06 #9d9b97
set $base07 #baae9e
set $base08 #cf6a4c
set $base09 #cf7d34
set $base0A #f9ee98
set $base0B #54be0d
set $base0C #afc4db
set $base0D #5ea6ea
set $base0E #9b859d
set $base0F #937121

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


