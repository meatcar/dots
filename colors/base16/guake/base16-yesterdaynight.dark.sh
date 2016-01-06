#!/usr/bin/env bash
# Base16 Yesterday Night - Guake Terminal color scheme install script
# FroZnShiva (https://github.com/FroZnShiva)


gconftool-2 -s -t string /apps/guake/style/background/color "#34343d3d4646"
gconftool-2 -s -t string /apps/guake/style/font/color "#dfdfe1e1e8e8"
gconftool-2 -s -t string /apps/guake/style/font/palette "#34343d3d4646:#cccc66666666:#b5b5bdbd6868:#f0f0c6c67474:#8181a2a2bebe:#b2b29494bbbb:#8a8abebeb7b7:#dfdfe1e1e8e8:#a7a7adadbaba:#cccc66666666:#b5b5bdbd6868:#f0f0c6c67474:#8181a2a2bebe:#b2b29494bbbb:#8a8abebeb7b7:#ffffffffffff"
