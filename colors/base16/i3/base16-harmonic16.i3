# ~/.i3/config
# i3 config template
# Base16 harmonic16 by Jannik Siebert (https://github.com/janniks)
# template by Matt Parnell, @parnmatt

set $base00 #0b1c2c
set $base01 #223b54
set $base02 #405c79
set $base03 #627e99
set $base04 #aabcce
set $base05 #cbd6e2
set $base06 #e5ebf1
set $base07 #f7f9fb
set $base08 #bf8b56
set $base09 #bfbf56
set $base0A #8bbf56
set $base0B #56bf8b
set $base0C #568bbf
set $base0D #8b56bf
set $base0E #bf568b
set $base0F #bf5656

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


