# ~/.i3/config
# i3 config template
# Base16 Seti UI by 
# template by Matt Parnell, @parnmatt

set $base00 #151718
set $base01 #8ec43d
set $base02 #3B758C
set $base03 #41535B
set $base04 #43a5d5
set $base05 #d6d6d6
set $base06 #eeeeee
set $base07 #ffffff
set $base08 #Cd3f45
set $base09 #db7b55
set $base0A #e6cd69
set $base0B #9fca56
set $base0C #55dbbe
set $base0D #55b5db
set $base0E #a074c4
set $base0F #8a553f

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


