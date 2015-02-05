#!/usr/bin/env bash
# Base16 Colors - Guake Terminal color scheme install script
# mrmrs (http://clrs.cc)


gconftool-2 -s -t string /apps/guake/style/background/color "#ffffffffffff"
gconftool-2 -s -t string /apps/guake/style/font/color "#555555555555"
gconftool-2 -s -t string /apps/guake/style/font/palette "#ffffffffffff:#ffff41413636:#2e2ecccc4040:#ffffdcdc0000:#00007474d9d9:#b1b10d0dc9c9:#7f7fdbdbffff:#bbbbbbbbbbbb:#777777777777:#ffff41413636:#2e2ecccc4040:#ffffdcdc0000:#00007474d9d9:#b1b10d0dc9c9:#7f7fdbdbffff:#111111111111"
