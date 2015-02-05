#!/usr/bin/env bash
# Base16 Summerfruit - Guake Terminal color scheme install script
# Christopher Corley (http://cscorley.github.io/)


gconftool-2 -s -t string /apps/guake/style/background/color "#FFFFFFFFFFFF"
gconftool-2 -s -t string /apps/guake/style/font/color "#303030303030"
gconftool-2 -s -t string /apps/guake/style/font/palette "#FFFFFFFFFFFF:#FFFF00008686:#0000C9C91818:#ABABA8A80000:#37377777E6E6:#ADAD0000A1A1:#1f1faaaaaaaa:#D0D0D0D0D0D0:#505050505050:#FFFF00008686:#0000C9C91818:#ABABA8A80000:#37377777E6E6:#ADAD0000A1A1:#1f1faaaaaaaa:#151515151515"
