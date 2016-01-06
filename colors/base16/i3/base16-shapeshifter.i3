# ~/.i3/config
# i3 config template
# Base16 shapeshifter by Tyler Benziger (http://tybenz.com)
# template by Matt Parnell, @parnmatt

set $base00 #000000
set $base01 #040404
set $base02 #102015
set $base03 #343434
set $base04 #555555
set $base05 #ababab
set $base06 #e0e0e0
set $base07 #f9f9f9
set $base08 #e92f2f
set $base09 #e09448
set $base0A #dddd13
set $base0B #0ed839
set $base0C #23edda
set $base0D #3b48e3
set $base0E #f996e2
set $base0F #69542d

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


