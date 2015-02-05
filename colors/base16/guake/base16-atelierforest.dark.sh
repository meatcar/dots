#!/usr/bin/env bash
# Base16 Atelier Forest - Guake Terminal color scheme install script
# Bram de Haan (http://atelierbram.github.io/syntax-highlighting/atelier-schemes/forest)


gconftool-2 -s -t string /apps/guake/style/background/color "#1b1b19191818"
gconftool-2 -s -t string /apps/guake/style/font/color "#a8a8a1a19f9f"
gconftool-2 -s -t string /apps/guake/style/font/palette "#1b1b19191818:#f2f22c2c4040:#5a5ab7b73838:#d5d591911a1a:#40407e7ee7e7:#66666666eaea:#0000adad9c9c:#a8a8a1a19f9f:#76766e6e6b6b:#f2f22c2c4040:#5a5ab7b73838:#d5d591911a1a:#40407e7ee7e7:#66666666eaea:#0000adad9c9c:#f1f1efefeeee"
