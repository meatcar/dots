# ~/.i3/config
# i3 config template
# Base16 Yesterday by FroZnShiva (https://github.com/FroZnShiva)
# template by Matt Parnell, @parnmatt

set $base00 #1d1f21
set $base01 #282a2e
set $base02 #4d4d4c
set $base03 #969896
set $base04 #8e908c
set $base05 #d6d6d6
set $base06 #efefef
set $base07 #ffffff
set $base08 #c82829
set $base09 #f5871f
set $base0A #eab700
set $base0B #718c00
set $base0C #3e999f
set $base0D #4271ae
set $base0E #8959a8
set $base0F #7f2a1d

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


