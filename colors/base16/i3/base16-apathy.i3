# ~/.i3/config
# i3 config template
# Base16 Apathy by Jannik Siebert (https://github.com/janniks)
# template by Matt Parnell, @parnmatt

set $base00 #031A16
set $base01 #0B342D
set $base02 #184E45
set $base03 #2B685E
set $base04 #5F9C92
set $base05 #81B5AC
set $base06 #A7CEC8
set $base07 #D2E7E4
set $base08 #3E9688
set $base09 #3E7996
set $base0A #3E4C96
set $base0B #883E96
set $base0C #963E4C
set $base0D #96883E
set $base0E #4C963E
set $base0F #3E965B

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


