# ~/.i3/config
# i3 config template
# Base16 Twilight by David Hart (http://hart-dev.com)
# template by Matt Parnell, @parnmatt

set $base00 #1e1e1e
set $base01 #323537
set $base02 #464b50
set $base03 #5f5a60
set $base04 #838184
set $base05 #a7a7a7
set $base06 #c3c3c3
set $base07 #ffffff
set $base08 #cf6a4c
set $base09 #cda869
set $base0A #f9ee98
set $base0B #8f9d6a
set $base0C #afc4db
set $base0D #7587a6
set $base0E #9b859d
set $base0F #9b703f

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


