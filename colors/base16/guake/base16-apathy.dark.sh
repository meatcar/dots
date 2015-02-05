#!/usr/bin/env bash
# Base16 Apathy - Guake Terminal color scheme install script
# Jannik Siebert (https://github.com/janniks)


gconftool-2 -s -t string /apps/guake/style/background/color "#03031A1A1616"
gconftool-2 -s -t string /apps/guake/style/font/color "#8181B5B5ACAC"
gconftool-2 -s -t string /apps/guake/style/font/palette "#03031A1A1616:#3E3E96968888:#88883E3E9696:#3E3E4C4C9696:#969688883E3E:#4C4C96963E3E:#96963E3E4C4C:#8181B5B5ACAC:#2B2B68685E5E:#3E3E96968888:#88883E3E9696:#3E3E4C4C9696:#969688883E3E:#4C4C96963E3E:#96963E3E4C4C:#D2D2E7E7E4E4"
