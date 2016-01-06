#!/usr/bin/env bash
# Base16 Atelier Sulphurpool - Guake Terminal color scheme install script
# Bram de Haan (http://atelierbram.github.io/syntax-highlighting/atelier-schemes/sulphurpool)


gconftool-2 -s -t string /apps/guake/style/background/color "#f5f5f7f7ffff"
gconftool-2 -s -t string /apps/guake/style/font/color "#5e5e66668787"
gconftool-2 -s -t string /apps/guake/style/font/palette "#f5f5f7f7ffff:#c9c949492222:#acac97973939:#c0c08b8b3030:#3d3d8f8fd1d1:#66667979cccc:#2222a2a2c9c9:#97979d9db4b4:#6b6b73739494:#c9c949492222:#acac97973939:#c0c08b8b3030:#3d3d8f8fd1d1:#66667979cccc:#2222a2a2c9c9:#202027274646"
