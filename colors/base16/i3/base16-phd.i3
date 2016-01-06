# ~/.i3/config
# i3 config template
# Base16 PhD by Hennig Hasemann (http://leetless.de/vim.html)
# template by Matt Parnell, @parnmatt

set $base00 #061229
set $base01 #2a3448
set $base02 #4d5666
set $base03 #717885
set $base04 #9a99a3
set $base05 #b8bbc2
set $base06 #dbdde0
set $base07 #ffffff
set $base08 #d07346
set $base09 #f0a000
set $base0A #fbd461
set $base0B #99bf52
set $base0C #72b9bf
set $base0D #5299bf
set $base0E #9989cc
set $base0F #b08060

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


