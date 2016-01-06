# ~/.i3/config
# i3 config template
# Base16 Ocean by Chris Kempson (http://chriskempson.com)
# template by Matt Parnell, @parnmatt

set $base00 #2b303b
set $base01 #343d46
set $base02 #4f5b66
set $base03 #65737e
set $base04 #a7adba
set $base05 #c0c5ce
set $base06 #dfe1e8
set $base07 #eff1f5
set $base08 #bf616a
set $base09 #d08770
set $base0A #ebcb8b
set $base0B #a3be8c
set $base0C #96b5b4
set $base0D #8fa1b3
set $base0E #b48ead
set $base0F #ab7967

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


