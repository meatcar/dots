# ~/.i3/config
# i3 config template
# Base16 Yesterday Bright by FroZnShiva (https://github.com/FroZnShiva)
# template by Matt Parnell, @parnmatt

set $base00 #343d46
set $base01 #4f5b66
set $base02 #65737e
set $base03 #a7adba
set $base04 #c0c5ce
set $base05 #dfe1e8
set $base06 #eff1f5
set $base07 #ffffff
set $base08 #d54e53
set $base09 #e78c45
set $base0A #e7c547
set $base0B #b9ca4a
set $base0C #70c0b1
set $base0D #7aa6da
set $base0E #c397d8
set $base0F #9a806d

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


