# ~/.i3/config
# i3 config template
# Base16 Ashes by Jannik Siebert (https://github.com/janniks)
# template by Matt Parnell, @parnmatt

set $base00 #1C2023
set $base01 #393F45
set $base02 #565E65
set $base03 #747C84
set $base04 #ADB3BA
set $base05 #C7CCD1
set $base06 #DFE2E5
set $base07 #F3F4F5
set $base08 #C7AE95
set $base09 #C7C795
set $base0A #AEC795
set $base0B #95C7AE
set $base0C #95AEC7
set $base0D #AE95C7
set $base0E #C795AE
set $base0F #C79595

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


