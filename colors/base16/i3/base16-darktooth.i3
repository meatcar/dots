# ~/.i3/config
# i3 config template
# Base16 Darktooth by Jason Milkins (https://github.com/jasonm23)
# template by Matt Parnell, @parnmatt

set $base00 #1D2021
set $base01 #32302F
set $base02 #504945
set $base03 #665C54
set $base04 #928374
set $base05 #A89984
set $base06 #D5C4A1
set $base07 #FDF4C1
set $base08 #FB543F
set $base09 #FE8625
set $base0A #FAC03B
set $base0B #95C085
set $base0C #8BA59B
set $base0D #0D6678
set $base0E #8F4673
set $base0F #A87322

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


