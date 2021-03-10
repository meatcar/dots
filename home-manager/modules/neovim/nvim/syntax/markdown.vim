" Custom conceal
scriptencoding utf-8
syntax match todoCheckbox "\[\ \]" conceal cchar=
syntax match todoCheckbox "\[x\]" conceal cchar=
syntax match todoCheckbox "\[-\]" conceal cchar=

hi def link todoCheckbox Todo
hi Conceal guibg=NONE
