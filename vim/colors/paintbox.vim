set background=dark "or light
highlight clear
if exists("syntax_on")
	syntax reset
endif
"let g:colors_name = "vivify"
set t_Co=256
highlight Boolean             guifg=#8b0000 ctermfg=88  guibg=#fee6ff ctermbg=225 gui=none cterm=none
highlight CTagsClass          guifg=#eeeeee ctermfg=255                           gui=none cterm=none
highlight CTagsGlobalConstant guifg=#eeeeee ctermfg=255                           gui=none cterm=none
highlight CTagsGlobalVariable guifg=#eeeeee ctermfg=255                           gui=none cterm=none
highlight CTagsImport         guifg=#eeeeee ctermfg=255                           gui=none cterm=none
highlight CTagsMember         guifg=#eeeeee ctermfg=255                           gui=none cterm=none
highlight Character           guifg=#8b0000 ctermfg=88  guibg=#fee6ff ctermbg=225 gui=none cterm=none
highlight Comment             guifg=#4682b4 ctermfg=67  guibg=#f0f6ff ctermbg=153 gui=none cterm=none
highlight Conditional         guifg=#f06f00 ctermfg=166 guibg=#fcecee ctermbg=204 gui=none cterm=none
highlight Constant            guifg=#8b0000 ctermfg=88  guibg=#fee6ff ctermbg=225 gui=none cterm=none
highlight Cursor              guifg=#ffffff ctermfg=15  guibg=#00008b ctermbg=18  gui=none cterm=none
highlight CursorColumn        guifg=#eeeeee ctermfg=255                           gui=none cterm=none
highlight CursorLine          guifg=#eeeeee ctermfg=255                           gui=none cterm=none
highlight Debug               guifg=#ee0000 ctermfg=196                           gui=none cterm=none
highlight Define              guifg=#1071ce ctermfg=25  guibg=#e3efff ctermbg=153 gui=none cterm=none
highlight DefinedName         guifg=#eeeeee ctermfg=255                           gui=none cterm=none
highlight Delimiter           guifg=#ee0000 ctermfg=196                           gui=none cterm=none
highlight DiffAdd             guifg=#2020ff ctermfg=21  guibg=#c8f2ea ctermbg=195 gui=none cterm=none
highlight DiffChange          guifg=#006800 ctermfg=22  guibg=#d0ffd0 ctermbg=194 gui=none cterm=none
highlight DiffDelete          guifg=#2020ff ctermfg=21  guibg=#c8f2ea ctermbg=195 gui=none cterm=none
highlight DiffText            guifg=#00c226 ctermfg=34  guibg=#dbf8e3 ctermbg=121 gui=none cterm=none
highlight Directory           guifg=#000080 ctermfg=18  guibg=#ffe9e3 ctermbg=224 gui=none cterm=none
highlight EnumerationName     guifg=#eeeeee ctermfg=255                           gui=none cterm=none
highlight EnumerationValue    guifg=#eeeeee ctermfg=255                           gui=none cterm=none
highlight Error               guifg=#ffffff ctermfg=15  guibg=#ff0000 ctermbg=196 gui=none cterm=none
highlight ErrorMsg            guifg=#eb1513 ctermfg=160                           gui=none cterm=none
highlight Exception           guifg=#f06f00 ctermfg=166 guibg=#fcece0 ctermbg=223 gui=none cterm=none
highlight Float               guifg=#00c226 ctermfg=34  guibg=#dbf8e3 ctermbg=121 gui=none cterm=none
highlight FoldColumn          guifg=#000000 ctermfg=0   guibg=#b5eeb5 ctermbg=151 gui=none cterm=none
highlight Folded              guifg=#000000 ctermfg=0   guibg=#b5eeb5 ctermbg=151 gui=none cterm=none
highlight Function            guifg=#0000ff ctermfg=21                            gui=none cterm=none
highlight Identifier          guifg=#0000ff ctermfg=21                            gui=none cterm=none
highlight Ignore              guifg=#eeeeee ctermfg=255                           gui=none cterm=none
highlight IncSearch           guifg=#ffffff ctermfg=15  guibg=#000080 ctermbg=18  gui=none cterm=none
highlight Include             guifg=#1071ce ctermfg=25  guibg=#e3efff ctermbg=153 gui=none cterm=none
highlight Keyword             guifg=#f06f00 ctermfg=166 guibg=#fcece0 ctermbg=223 gui=none cterm=none
highlight Label               guifg=#f06f00 ctermfg=166 guibg=#fcece0 ctermbg=223 gui=none cterm=none
highlight LineNr              guifg=#8080a0 ctermfg=103                           gui=none cterm=none
highlight LocalVariable       guifg=#eeeeee ctermfg=255                           gui=none cterm=none
highlight Macro               guifg=#1071ce ctermfg=25  guibg=#e3efff ctermbg=153 gui=none cterm=none
highlight MatchParen          guifg=#000000 ctermfg=0   guibg=#b5eeb5 ctermbg=151 gui=bold cterm=bold
highlight ModeMsg             guifg=#0070ff ctermfg=27                            gui=none cterm=none
highlight MoreMsg             guifg=#2e8b57 ctermfg=72                            gui=none cterm=none
highlight NonText             guifg=#4000ff ctermfg=57  guibg=#ffffff ctermbg=15  gui=none cterm=none
highlight Normal              guifg=#00008b ctermfg=18  guibg=#f5f5f5 ctermbg=255 gui=none cterm=none
highlight Number              guifg=#00c226 ctermfg=34  guibg=#dbf8e3 ctermbg=121 gui=none cterm=none
highlight Operator            guifg=#f06f00 ctermfg=166 guibg=#fcece0 ctermbg=223 gui=none cterm=none
highlight PMenu               guifg=#000000 ctermfg=0   guibg=#bddfff ctermbg=153 gui=none cterm=none
highlight PMenuSbar           guifg=#cccccc ctermfg=252 guibg=#cccccc ctermbg=252 gui=none cterm=none
highlight PMenuSel            guifg=#000000 ctermfg=0   guibg=#ffa500 ctermbg=214 gui=none cterm=none
highlight PMenuThumb          guifg=#000000 ctermfg=0   guibg=#aaaaaa ctermbg=248 gui=none cterm=none
highlight PreCondit           guifg=#1071ce ctermfg=25  guibg=#e3efff ctermbg=153 gui=none cterm=none
highlight PreProc             guifg=#1071ce ctermfg=25  guibg=#e3efff ctermbg=153 gui=none cterm=none
highlight Question            guifg=#2e8b57 ctermfg=72                            gui=none cterm=none
highlight Repeat              guifg=#f06f00 ctermfg=166 guibg=#fcece0 ctermbg=223 gui=none cterm=none
highlight Search              guifg=#00008b ctermfg=18  guibg=#ffe270 ctermbg=221 gui=none cterm=none
highlight SignColumn          guifg=#eeeeee ctermfg=255                           gui=none cterm=none
highlight Special             guifg=#ee0000 ctermfg=196                           gui=none cterm=none
highlight SpecialChar         guifg=#ee0000 ctermfg=196                           gui=none cterm=none
highlight SpecialComment      guifg=#ee0000 ctermfg=196                           gui=none cterm=none
highlight SpecialKey          guifg=#eeeeee ctermfg=255                           gui=none cterm=none
highlight SpellBad            guifg=#eeeeee ctermfg=255 guibg=#8080ff ctermbg=12  gui=none cterm=none
highlight SpellCap            guifg=#eeeeee ctermfg=255 guibg=#ff6060 ctermbg=9   gui=none cterm=none
highlight SpellLocal          guifg=#eeeeee ctermfg=255                           gui=none cterm=none
highlight SpellRare           guifg=#eeeeee ctermfg=255 guibg=#ff40ff ctermbg=13  gui=none cterm=none
highlight Statement           guifg=#f06f00 ctermfg=166 guibg=#fcece0 ctermbg=223 gui=none cterm=none
highlight StatusLine          guifg=#f5f5f5 ctermfg=255 guibg=#4682b4 ctermbg=67  gui=none cterm=none
highlight StatusLineNC        guifg=#ffffff ctermfg=15  guibg=#add8e6 ctermbg=81  gui=none cterm=none
highlight StorageClass        guifg=#b91f49 ctermfg=204 guibg=#ffe3e5 ctermbg=204 gui=none cterm=none
highlight String              guifg=#8b0000 ctermfg=88  guibg=#fee6ff ctermbg=225 gui=none cterm=none
highlight Structure           guifg=#b91f49 ctermfg=204 guibg=#ffe3e5 ctermbg=204 gui=none cterm=none
highlight TabLine             guifg=#000000 ctermfg=0   guibg=#d3d3d3 ctermbg=252 gui=underline cterm=underline
highlight TabLineFill         guifg=#eeeeee ctermfg=255                           gui=none cterm=none
highlight TabLineSel          guifg=#eeeeee ctermfg=255                           gui=bold cterm=bold
highlight Tag                 guifg=#006400 ctermfg=22                            gui=none cterm=none
highlight Title               guifg=#1014ad ctermfg=19                            gui=none cterm=none
highlight Todo                guifg=#00008b ctermfg=18  guibg=#ff0000 ctermbg=196 gui=none cterm=none
highlight Type                guifg=#b91f49 ctermfg=204 guibg=#ffe3e5 ctermbg=204 gui=none cterm=none
highlight Typedef             guifg=#b91f49 ctermfg=204 guibg=#ffe3e5 ctermbg=204 gui=none cterm=none
highlight Underlined          guifg=#eeeeee ctermfg=255                           gui=none cterm=none
highlight Union               guifg=#eeeeee ctermfg=255                           gui=none cterm=none
highlight VertSplit           guifg=#ffffff ctermfg=15  guibg=#add8e6 ctermbg=81  gui=none cterm=none
highlight Visual              guifg=#000000 ctermfg=0   guibg=#d6e3f8 ctermbg=153 gui=none cterm=none
highlight VisualNOS           guifg=#000000 ctermfg=0   guibg=#bddfff ctermbg=153 gui=none cterm=none
highlight WarningMsg          guifg=#eb1513 ctermfg=160                           gui=none cterm=none
highlight WildMenu            guifg=#ffffff ctermfg=15  guibg=#e9967a ctermbg=209 gui=none cterm=none
highlight pythonBuiltin       guifg=#00008b ctermfg=18                            gui=none cterm=none
highlight JavaScriptStrings   guifg=#eeeeee ctermfg=255                           gui=none cterm=none
highlight phpStringSingle     guifg=#eeeeee ctermfg=255                           gui=none cterm=none
highlight phpStringDouble     guifg=#eeeeee ctermfg=255                           gui=none cterm=none
highlight htmlString          guifg=#eeeeee ctermfg=255                           gui=none cterm=none
highlight htmlTagName         guifg=#eeeeee ctermfg=255                           gui=none cterm=none
