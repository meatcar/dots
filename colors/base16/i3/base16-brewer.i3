# ~/.i3/config
# i3 config template
# Base16 Brewer by Timothée Poisot (http://github.com/tpoisot)
# template by Matt Parnell, @parnmatt

set $base00 #0c0d0e
set $base01 #2e2f30
set $base02 #515253
set $base03 #737475
set $base04 #959697
set $base05 #b7b8b9
set $base06 #dadbdc
set $base07 #fcfdfe
set $base08 #e31a1c
set $base09 #e6550d
set $base0A #dca060
set $base0B #31a354
set $base0C #80b1d3
set $base0D #3182bd
set $base0E #756bb1
set $base0F #b15928

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


