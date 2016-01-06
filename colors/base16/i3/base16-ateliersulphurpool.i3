# ~/.i3/config
# i3 config template
# Base16 Atelier Sulphurpool by Bram de Haan (http://atelierbram.github.io/syntax-highlighting/atelier-schemes/sulphurpool)
# template by Matt Parnell, @parnmatt

set $base00 #202746
set $base01 #293256
set $base02 #5e6687
set $base03 #6b7394
set $base04 #898ea4
set $base05 #979db4
set $base06 #dfe2f1
set $base07 #f5f7ff
set $base08 #c94922
set $base09 #c76b29
set $base0A #c08b30
set $base0B #ac9739
set $base0C #22a2c9
set $base0D #3d8fd1
set $base0E #6679cc
set $base0F #9c637a

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


