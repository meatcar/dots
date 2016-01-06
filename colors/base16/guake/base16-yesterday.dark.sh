#!/usr/bin/env bash
# Base16 Yesterday - Guake Terminal color scheme install script
# FroZnShiva (https://github.com/FroZnShiva)


gconftool-2 -s -t string /apps/guake/style/background/color "#1d1d1f1f2121"
gconftool-2 -s -t string /apps/guake/style/font/color "#d6d6d6d6d6d6"
gconftool-2 -s -t string /apps/guake/style/font/palette "#1d1d1f1f2121:#c8c828282929:#71718c8c0000:#eaeab7b70000:#42427171aeae:#89895959a8a8:#3e3e99999f9f:#d6d6d6d6d6d6:#969698989696:#c8c828282929:#71718c8c0000:#eaeab7b70000:#42427171aeae:#89895959a8a8:#3e3e99999f9f:#ffffffffffff"
