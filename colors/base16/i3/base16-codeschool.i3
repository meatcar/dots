# ~/.i3/config
# i3 config template
# Base16 Codeschool by brettof86
# template by Matt Parnell, @parnmatt

set $base00 #232c31
set $base01 #1c3657
set $base02 #2a343a
set $base03 #3f4944
set $base04 #84898c
set $base05 #9ea7a6
set $base06 #a7cfa3
set $base07 #b5d8f6
set $base08 #2a5491
set $base09 #43820d
set $base0A #a03b1e
set $base0B #237986
set $base0C #b02f30
set $base0D #484d79
set $base0E #c59820
set $base0F #c98344

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


