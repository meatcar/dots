" vim: ai:et:ts=2:sw=2:ft=vim:foldmethod=marker :

" General {{{
augroup vimrc
  autocmd!
augroup END

set shell=sh              " fastest shell!

set t_Co=256              " enable 256-color support
if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors       " enable true colors support
endif

set title

set encoding=utf-8        " UTF-8 encoding for all new files
scriptencoding 'utf-8'
set termencoding=utf-8    " force terminal encoding

set ttyfast               " tell vim we're using a fast terminal for redraws
set lazyredraw            " don't redraw while running commands

set mouse=a               " allow mouse input in all modes
if has("mouse_sgr")       " fix mouse in tmux
  set ttymouse=sgr
elseif !has('nvim')
  set ttymouse=xterm2
endif

set autowrite             " write file if modified on each :next, :make, etc.
set hidden                " un-saved buffers in the background
set undofile              " maintain undo history

set nonumber              " show line numbers
set norelativenumber      " show line numbers
set numberwidth=1         " minimum num of cols to reserve for line numbers

set showmatch             " show matching brackets (),{},[]
set matchpairs+=<:>       " and <>
set whichwrap=h,l,<,>,[,] " whichwrap -- left/right keys can traverse up/down
set wrap                  " wrap long lines to fit terminal width
set wrapmargin=0

set textwidth=0           " don't break lines
set linebreak             " soft-wrap lines, don't break them (bad opt name)
if exists('+breakindent') " move soft-wrapped lines to match the indent level.
  set breakindent
  set breakindentopt=shift:2
  let &showbreak='↳ '
endif

set splitbelow            " place the new split below the current file
set splitright            " place the new split to the right of the current file
set previewheight=9       " default height for a preview window (def:12)

set wildmode=longest,list:longest

if has('nvim-0.4.0')
  set pumblend=50           " neovim popup window blend
  set wildoptions=pum       " use popup window for wildmenu
endif

if has('nvim-0.3.2') || has("patch-8.1.0360")
    set diffopt=filler,internal,algorithm:histogram,indent-heuristic
endif
set diffopt-=iwhite       " ignore whitespace when diffing
let &listchars='tab:⇥ ,eol:$,trail:·,extends:>,precedes:<' " set list
let &fillchars='vert:│,fold: '
"}}}

" Completion {{{
set noshowmode shortmess+=c
set noinfercase
set completeopt=noinsert,menuone,noselect
"}}}

" Folds {{{
set foldmethod=syntax
set viewoptions=cursor,folds,slash,unix " save folds, cursor position
set foldopen=block,hor,insert,jump,mark,percent,quickfix,search,tag,undo
"}}}

" Tabs and indenting {{{
set expandtab             " insert spaces instead of tabs
set tabstop=4             " n space tab width
set shiftwidth=4          " allows the use of < and > for VISUAL indenting
set softtabstop=4         " counts n spaces when DELETE or BCKSPCE is used
set nocindent             " C style indenting off
set formatoptions=tcqr    " recommended defaults from O'Reilly
"}}}

" Searching {{{
set hlsearch            " highlight all search results
set ignorecase          " case-insensitive search
set smartcase           " uppercase causes case-sensitive search
set wrapscan            " searches wrap back to the top of file
"}}}

" gVIM settings {{{
if has('gui_running')
  " Set the font
  if has('unix')
    let s:uname = system('uname')
    if s:uname ==? 'Darwin\n' " osx
      set guifont=Fantasque\ Sans\ Mono:h10,Monaco:h10
    else " linux
      set linespace=0
      set guifont=Iosevka\ SS07\ 10,Iosevka\ 10,Monospace\ 10,FontAwesome\ 10,EmojiOne\ Color\ 10
    endif
  elseif has('win32') || has('win64')
    set guifont=Fantasque\ Sans\ Mono:h10,Consolas:h10
  endif

  set guioptions-=T      "hide the toolbar
  set guioptions-=m      "hide the manubar
endif

if exists('g:GuiLoaded')
  GuiFont monospace:h9
endif
"}}}

" Packages {{{
" auto-install packager {{{
if empty(glob($XDG_DATA_HOME."/nvim/pack/packager/opt/packager"))
  silent !git clone 'https://github.com/kristijanhusak/vim-packager'
        \ $XDG_DATA_HOME"/nvim/pack/packager/opt/packager"
endif
"}}}

" Package commands {{{
command! -bar -nargs=+ Pack call packager#add(<args>)
command! PackInstall packadd packager | source $MYVIMRC | call packager#install()
command! -bang PackInstall packadd packager | source $MYVIMRC | call packager#update({ 'force_hooks': '<bang>' })
command! PackClean   packadd packager | source $MYVIMRC | call packager#clean()
command! PackStatus  packadd packager | source $MYVIMRC | call packager#status()
"}}}

if exists('*packager#init')
  " only work with packages if packager is loaded
  call packager#init()

  " Simple Sane QoL Packages {{{
  Pack 'kristijanhusak/vim-packager', { 'type': 'opt', 'name': 'packager' }
  Pack 'tpope/vim-sensible'            " sane defaults
  Pack 'tpope/vim-sleuth'              " auto-detect tabs
  Pack 'tpope/vim-eunuch'              " helpful Unix commands (:Rename, etc)
  Pack 'tpope/vim-commentary'          " easy commenting with `gcc`
  " Pack 'tpope/vim-surround'            " surround stuff!
  Pack 'machakann/vim-sandwich'        " better surround
  Pack 'wellle/targets.vim'
  Pack 'tpope/vim-repeat'              " repeat all the things
  Pack 'tpope/vim-endwise'             " add `end` do function blocks
  Pack 'tpope/vim-unimpaired'          " complimentary mapping pairs ([b, ]b)
  Pack 'pbrisbin/vim-mkdir'            " mkdir of current file if it doesn't exist
  Pack 'kopischke/vim-stay'            " save folds
  Pack 'kopischke/vim-fetch'           " parse '...:{num}' from files, jump to line
  Pack 'moll/vim-bbye'                 " :Bdelete, kill current buffer, not window
  Pack 'xtal8/traces.vim'              " preview ex commands like :s///
  Pack 'airblade/vim-rooter'           " auto-cd to vcs root
  Pack 'Konfekt/FoldText'              " Fancy fold texts
  Pack 'Konfekt/FastFold'              " lazy-folds because folding is heavy
  Pack 'aymericbeaumet/symlink.vim'    " edit the actual file when opening symlinks
  Pack 'thinca/vim-fontzoom', {'type': 'opt'}  " zoom font in gvim
  Pack 'junegunn/vim-peekaboo'         " show a popup of vim registers
  "}}}

  " Snippets {{{
  Pack 'SirVer/ultisnips'
  Pack 'honza/vim-snippets'
  " "}}}

  " Completion {{{
  Pack 'ncm2/ncm2'
  Pack 'roxma/nvim-yarp'
  Pack 'ncm2/ncm2-bufword'
  Pack 'fgrsnau/ncm2-otherbuf'
  Pack 'ncm2/ncm2-path'
  Pack 'ncm2/ncm2-github'
  Pack 'ncm2/ncm2-ultisnips'
  Pack 'wellle/tmux-complete.vim'
  Pack 'ncm2/ncm2-markdown-subscope'
  Pack 'ncm2/ncm2-html-subscope'
  Pack 'ncm2/float-preview.nvim'

  " }}}

  " Git {{{
  Pack 'tpope/vim-rhubarb'             " auto-complete Github issues in fugitive
  Pack 'tpope/vim-fugitive'            " tight git integration
  Pack 'mhinz/vim-signify'             " show git changes in the gutter
  Pack 'samoshkin/vim-mergetool'       " Better merging (3-way becomes 2-way)
  Pack 'shumphrey/fugitive-gitlab.vim' " Gitlab support for fugitive
  Pack 'rhysd/git-messenger.vim'       " pop-up window of git commit under cursor
  Pack 'sodapopcan/vim-twiggy'         " pop-up git branches
  Pack 'rbong/vim-flog'                " pretty git log
  Pack 'lambdalisue/gina.vim'          " fast git
  Pack 'lambdalisue/vim-gista'         " post to gist.github.com
  "}}}

  " Nice Utilities {{{
  Pack 'simnalamburt/vim-mundo', {'on': 'MundoToggle'} " undo tree
  Pack 'junegunn/vim-easy-align'                       " align things easily
  Pack 'Olical/vim-enmasse'                            " mass edit every line in a quickfix
  Pack 'editorconfig/editorconfig-vim'
  Pack 'desmap/ale-sensible'                           " sensible ALE defaults
  Pack 'dense-analysis/ale'                            " async error checking
  Pack 'junegunn/fzf', { 'dir': '~/.fzf', 'do': 'which fzf && yes \| ./install'}
  Pack 'junegunn/fzf.vim'                              " fuzzy completion of all the things
  Pack 'justinmk/vim-dirvish'                          " nice simple file browser
  Pack 'AndrewRadev/splitjoin.vim'                     " single <> multi line code conversion
  Pack 'kshenoy/vim-signature'                         " show marks in the SignColumn
  Pack 'scrooloose/nerdtree'                           " tree sidebar
  Pack 'janko/vim-test'                                " run tests easily
  Pack 'https://git.danielmoch.com/vim-smartsplit.git' " Split smartly based on terminal width
  "}}}

  " Tmux {{{
  Pack 'tmux-plugins/vim-tmux-focus-events'  " focus events in tmux
  Pack 'christoomey/vim-tmux-navigator'      " <C-hjkl> to switch vim & tmux panes
  Pack 'roxma/vim-tmux-clipboard'            " sync vim + tmux clipboards
  Pack 'benmills/vimux'                      " programatically open tmux panes from vim
  "}}}

  " Colorschemes {{{
  " Pack 'flazz/vim-colorschemes'       " all the colorschemes
  Pack 'gruvbox-community/gruvbox'    " a theme to keep coming back to.
  Pack 'NLKNguyen/papercolor-theme'
  Pack 'liuchengxu/space-vim-theme'
  " Pack 'chriskempson/base16-vim'
  Pack 'https://gitlab.com/protesilaos/tempus-themes-vim' " accessible themes
  "}}}

  " Pretty Packages {{{
  Pack 'mhinz/vim-startify'           " startup screen
  Pack 'liuchengxu/vim-which-key'     " popup ui for obscure keys
  Pack 'ryanoasis/vim-devicons'       " pretty icons
  Pack 'kien/rainbow_parentheses.vim' " rainbow parentheses
  Pack 'psliwka/vim-smoothie'         " smooth scrolling
  Pack 'drzel/vim-line-no-indicator'  " pretty position-in-file indicator
  Pack 'drzel/vim-scrolloff-fraction' " scrolloff as a fraction of window height
  "}}}

  " Syntaxes {{{
  Pack 'sheerun/vim-polyglot'                     " A tonne of new syntaxes.
  Pack 'tpope/vim-markdown', {'type': 'opt'}
  Pack 'SidOfc/mkdx', {'type': 'opt'}             " Fancy markdown extras
  Pack 'reedes/vim-pencil', { 'type': 'opt' }     " make editing freetext easier

  Pack 'zirrostig/vim-shbed', {'type': 'opt' }    " highlight awk in shell scripts
  Pack 'vim-scripts/TeX-9', {'type': 'opt'}       " latex
  Pack 'mattn/emmet-vim', {'type': 'opt'}         " fast html editing

  Pack 'neomutt/neomutt.vim', {'type': 'opt'}

  Pack 'tpope/vim-classpath', {'type': 'opt'}     " figure out the Java classpath
  Pack 'tpope/vim-salve', {'type': 'opt'}         " static support for Leiningen
  Pack 'tpope/vim-projectionist', {'type': 'opt'} " for vim-salve, quick-switch between src and test
  Pack 'eraserhd/parinfer-rust',
        \ {'type': 'opt', 'do': 'nix-shell --run \"cargo build --release \"'}
                                                  " infer parens from indentation
  Pack 'liquidz/vim-iced', {'type': 'opt'}        " Clojure Interactive Development Environment
  "}}}
endif
"}}}

" Package Settings {{{

" Whichkey {{{
set timeoutlen=500     " speed up whichkey
let g:mapleader = "\<Space>"
let g:maplocalleader = ','
nmap <silent> <leader>          :<c-u>WhichKey         '<leader>'<CR>
vmap <silent> <leader>          :<c-u>WhichKeyVisual   '<leader>'<CR>
nnoremap <silent> <localleader>     :<c-u>WhichKey         '<localleader>'<CR>
vnoremap <silent> <localleader>     :<c-u>WhichKeyVisual   '<localleader>'<CR>
inoremap <silent> <C-,>   <c-\><c-o>:<c-u>WhichKey '<localleader>'<CR>
" }}}

" vim-signify {{{
let g:signify_vcs_list        = [ 'git' ]
let g:signify_sign_change     = '~'
let g:signify_sign_show_count = 1

autocmd vimrc FileType * highlight SignifySignAdd    ctermbg=none ctermfg=2 guibg=bg guifg=green
autocmd vimrc FileType * highlight SignifySignDelete ctermbg=none ctermfg=1 guibg=bg guifg=#ff3333
autocmd vimrc FileType * highlight SignifySignChange ctermbg=none ctermfg=3 guibg=bg guifg=yellow
autocmd vimrc FileType * highlight link SignifySignChangeDelete    SignifySignChange
autocmd vimrc FileType * highlight link SignifySignDeleteFirstLine SignifySignDelete
"}}}

" Editorconfig {{{
let g:EditorConfig_exclude_patterns = ['fugitive://.*']
"}}}

" ALE {{{
" let g:ale_javascript_eslint_executable = 'eslint_d'
" let g:ale_javascript_eslint_use_global = 1
let g:ale_linter_aliases = {
      \'vimwiki': 'markdown',
      \}
let g:ale_lint_on_text_changed = 'never'
let g:ale_fixers = {
      \   'javascript': ['eslint', 'prettier'],
      \   'css':        ['stylelint'],
      \   'scss':       ['stylelint'],
      \   'python':     ['autopep8'],
      \   'nix':        ['nixpkgs-fmt'],
      \}
let g:ale_fix_on_save = 1
" let g:ale_open_list = 1
" let g:ale_list_window_size = 3
"}}}

" FZF {{{

" An action can be a reference to a function that processes selected lines
function! s:build_quickfix_list(lines)
  call setqflist(map(copy(a:lines), "{ 'filename': v:val }"))
  copen
  wincmd p
endfunction

let g:fzf_action = {
      \ 'ctrl-q': function('s:build_quickfix_list'),
      \ 'ctrl-t': 'tab split',
      \ 'ctrl-x': 'split',
      \ 'ctrl-v': 'vsplit' }

let $FZF_DEFAULT_OPTS = '--bind ctrl-a:select-all'

" Customize fzf colors to match your color scheme
let g:fzf_colors =
      \ { 'fg':      ['fg', 'Normal'],
      \ 'bg':      ['bg', 'Normal'],
      \ 'hl':      ['fg', 'Comment'],
      \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
      \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
      \ 'hl+':     ['fg', 'Statement'],
      \ 'info':    ['fg', 'PreProc'],
      \ 'border':  ['fg', 'Ignore'],
      \ 'prompt':  ['fg', 'Conditional'],
      \ 'pointer': ['fg', 'Exception'],
      \ 'marker':  ['fg', 'Keyword'],
      \ 'spinner': ['fg', 'Label'],
      \ 'header':  ['fg', 'Comment'] }

" Float it if possible
if has('nvim')
  let $FZF_DEFAULT_OPTS .= ' --layout=reverse' " --margin 0,1 --border'
  function! CreateCenteredFloatingWindow()
    let width = min([&columns - 4, max([80, &columns / 2])])
    let height = min([&lines - 4, max([5, &lines / 3])])
    let top = 0 "((&lines - height) / 2) - 1
    let left = (&columns - width) / 2
    let opts = {'relative': 'editor', 'row': top, 'col': left, 'width': width, 'height': height, 'style': 'minimal'}

    let top = "╭" . repeat("─", width - 2) . "╮"
    let mid = "│" . repeat(" ", width - 2) . "│"
    let bot = "╰" . repeat("─", width - 2) . "╯"
    " let lines = [top] + repeat([mid], height - 2) + [bot]
    let lines = repeat([mid], height - 1) + [bot]
    let s:buf = nvim_create_buf(v:false, v:true)
    call nvim_buf_set_lines(s:buf, 0, -1, v:true, lines)
    call nvim_open_win(s:buf, v:true, opts)
    set winhl=Normal:Floating
    let opts.row += 1
    let opts.height -= 2
    let opts.col += 2
    let opts.width -= 4
    call nvim_open_win(nvim_create_buf(v:false, v:true), v:true, opts)
    au BufWipeout <buffer> exe 'bw '.s:buf
  endfunction

  let g:fzf_layout = { 'window': 'call CreateCenteredFloatingWindow()' }

endif
"}}}

" vim-vinegar {{{
let g:netrw_altfile = 1
let g:netrw_keepdir = 0
let g:netrw_liststyle = 1
let g:netrw_hide = 1
let g:netrw_special_syntax = 'true'
let g:netrw_sort_options = 'i'
let g:netrw_localrmdir='rm -r'
"}}}

" vim-pencil {{{
let g:pencil_gutter_color = 1
"}}}

" gist-vim {{{
if $WAYLAND_DISPLAY
  let g:gist_clip_command = 'wl-copy'
else
  let g:gist_clip_command = 'xclip -selection clipboard'
endif
let g:gist_detect_filetype = 1
let g:gist_open_browser_after_post = 1
let g:gist_browser_command = 'xdg-open %URL% &'
"}}}

" vim-startify {{{
let g:startify_custom_indices = map(range(1,100), 'string(v:val)') " start with 1
let g:startify_session_dir = $XDG_CACHE_HOME.'/nvim/session'
let g:startify_skiplist = [
      \ 'COMMIT_EDITMSG',
      \ 'pack/.*/doc',
      \ escape(fnamemodify(resolve($VIMRUNTIME), ':p'), '\') .'doc',
      \ ]
let g:startify_custom_footer =
      \ ['', "   Vim is charityware. Please read ':help uganda'.", '']

let g:startify_custom_header = [
      \ '',
      \ '    __   _(_)_ __ ___  ',
      \ "    \\ \\ / / | '_ ` _ \\ ",
      \ '     \ V /| | | | | | |',
      \ '   n  \_/ |_|_| |_| |_|'
      \ ]

let g:startify_session_autoload = 1
let g:startify_session_persistence = 1
let g:startify_session_delete_buffers = 1
let g:startify_change_to_vcs_root = 1
autocmd vimrc User Startified setlocal buftype=nofile
" devicons
function! StartifyEntryFormat()
    return 'WebDevIconsGetFileTypeSymbol(absolute_path) ." ". entry_path'
endfunction
"}}}

" polyglot {{{
let g:polyglot_disabled = ['markdown']
" }}}

" mkdx {{{
let g:mkdx#settings = {
      \ 'image_extension_pattern': 'a\?png\|jpe\?g\|gif',
      \ 'restore_visual':          1,
      \ 'enter':                   { 'enable': 1, 'shift': 0, 'o': 1,
      \                              'shifto': 1, 'malformed': 1 },
      \ 'map':                     { 'prefix': '<localleader>', 'enable': 0 },
      \ 'tokens':                  { 'enter':  ['-', '*', '>'],
      \                              'bold':   '**', 'italic': '*',
      \                              'strike': '',
      \                              'list':   '-',  'fence':  '',
      \                              'header': '#' },
      \ 'checkbox':                { 'toggles': [' ', '-', 'x'],
      \                              'update_tree': 2,
      \                              'initial_state': ' ' },
      \ 'toc':                     { 'text':       "TOC",
      \                              'list_token': '-',
      \                              'position':   0,
      \                              'update_on_write':   0,
      \                              'details':    {
      \                                 'enable':  0,
      \                                 'summary': '{{toc.text}}',
      \                                 'nesting_level': -1,
      \                                 'child_count': 5,
      \                                 'child_summary': 'show {{count}} items'
      \                              }
      \                            },
      \ 'table':                   { 'divider': '|',
      \                              'header_divider': '-',
      \                              'align': {
      \                                 'left':    [],
      \                                 'right':   [],
      \                                 'center':  [],
      \                                 'default': 'center'
      \                              }
      \                            },
      \ 'links':                   { 'external': {
      \                                 'enable':     0,
      \                                 'timeout':    3,
      \                                 'host':       '',
      \                                 'relative':   1,
      \                                 'user_agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/9001.0.0000.000 vim-mkdx/1.9.0'
      \                              },
      \                              'fragment': {
      \                                 'jumplist': 1,
      \                                 'complete': 1
      \                              }
      \                            },
      \ 'highlight':               { 'enable': 0 },
      \ 'auto_update':             { 'enable': 1 },
      \ 'fold':                    { 'enable': 0, 'components': ['toc', 'fence'] }
      \ }

" }}}

" Emmet {{{
let g:user_emmet_leader_key = '<localleader>'
let g:user_emmet_install_global = 0
" }}}

" Dirvish {{{
autocmd vimrc FileType dirvish sort ,^.*[\/], | silent keeppatterns g@\v/\.[^\/]+/?$@d _
" }}}

  " Paredit {{{
  let g:paredit_leader=","
  let g:paredit_smartjump=1
  "}}}

  " peekaboo {{{
  " let g:peekaboo_window = "vert bo 30new"
  let g:peekaboo_delay = 300
  let g:peekaboo_compact = 1
  " "}}}

  " ncm2 {{{
  autocmd vimrc BufEnter * call ncm2#enable_for_buffer()

  func! config#expand_snippet()
    if ncm2_ultisnips#completed_is_snippet()
      call feedkeys("\<Plug>(ncm2_ultisnips_expand_completed)", "m")
    endif
    return ''
  endfunc

  " UltiSnips integration
  autocmd vimrc BufNewFile,BufRead *
        \ inoremap <silent> <expr> <cr> pumvisible() ? "\<c-y>\<c-r>=config#expand_snippet()\<cr>" : "\<cr>"
  let g:UltiSnipsExpandTrigger            = "<Plug>(ultisnips_expand)"
  let g:UltiSnipsJumpForwardTrigger       = "<c-j>"
  let g:UltiSnipsJumpBackwardTrigger      = "<c-k>"
  let g:UltiSnipsRemoveSelectModeMappings = 0
"}}}

" Colors {{{
let ayucolor="dark"
let g:gruvbox_italic = 1
let g:gruvbox_invert_selection = 0
let g:gruvbox_contrast_dark = 'hard'
let g:gruvbox_sign_column = 'bg0'
let g:gruvbox_color_column = 'bg0'
let g:afterglow_blackout = 1
let g:afterglow_italic_comments = 1
let g:afterglow_inherit_background = 1
let g:dracula_bold = 1
let g:dracula_italic = 1
let g:dracula_colorterm = 0
let g:PaperColor_Theme_Options = {
  \   'theme': {
  \     'default.dark': {
  \       'transparent_background': 1
  \     }
  \   }
  \ }
let g:two_firewatch_italics = 1
let g:space_vim_italic = 1

fun! MaybeTransparentBackground()
  " Make background transparent if background=dark
  if &background == 'dark'
    hi Normal       ctermbg=NONE guibg=NONE
    hi LineNr       ctermbg=NONE guibg=NONE
    hi SignColumn   ctermbg=NONE guibg=NONE
    hi FoldColumn   ctermbg=NONE guibg=NONE
    hi CursorLineNr ctermbg=NONE guibg=NONE
    hi VertSplit    ctermbg=NONE guibg=NONE
  endif
endfun

fun! SetTheme()
  if &background == 'dark'
    colorscheme gruvbox
  else
    colorscheme base16-summerfruit-light
  endif
endfun

autocmd vimrc OptionSet background call SetTheme()

" Fix old themes colouring SignColumn an ugly grey:
autocmd vimrc ColorScheme *
      \  hi clear SignColumn
      \| hi! link SignColumn LineNr
      " \| call MaybeTransparentBackground()

if has('gui_running')
  set background=light
else
  set background=dark
endif
call SetTheme()
"}}}

" Filetypes, Syntaxes, and AutoCMDs {{{

autocmd vimrc FileType shell,fish packadd vim-shbed
autocmd vimrc FileType fish compiler fish
autocmd vimrc BufRead,BufNewFile PKGBUILD set ft=sh

let g:tex_nine_config = {
      \'compiler': 'pdflatex',
      \'viewer': {'app':'zathura', 'target':'pdf'}
      \}
autocmd vimrc FileType tex,latex packadd 'TeX-9'

autocmd vimrc FileType *html*,*handlebars*,*css*,*less*,*sass*,*scss*,*jsx*
      \ packadd emmet-vim | EmmetInstall
autocmd vimrc FileType mail packadd 'neomutt.vim'
autocmd vimrc FileType clojure packadd vim-classpath
      \| packadd vim-projectionist | packadd vim-salve
      \| packadd parinfer-rust
      \| packadd vim-iced
      " \| packadd vim-cljfmt
      " \| packadd vim-fireplace

" Javascript
autocmd vimrc BufNewFile,BufRead *.jsx set filetype=javascript.jsx
autocmd vimrc BufNewFile,BufRead *.vue set filetype=vue.html.javascript.css
let g:vue_disable_pre_processors=1

"remove trailing whitespace upon save
fun! EnableStripTrailingWhitespace()
  " Only strip if the b:noStripeWhitespace variable isn't set
  if exists('b:noStripWhitespace')
    return
  endif
  autocmd BufWritePre * :%s/\s\+$//e
endfun

autocmd FileType markdown let b:noStripWhitespace=1
autocmd Filetype * call EnableStripTrailingWhitespace()

" Pack 'tomtom/foldtext_vim'
" autocmd vimrc FileType org,tex,latex,markdown,asciidoc packadd foldtext_vim
autocmd vimrc FileType md,markdown,mail setlocal spell
autocmd vimrc BufRead,BufNewFile mail set tw=0
autocmd vimrc BufRead,BufNewFile mail set wrapmargin=3

autocmd vimrc FileType md,markdown,text,mail packadd vim-pencil

autocmd vimrc BufNewFile,BufRead *.md set filetype=markdown
autocmd vimrc FileType markdown packadd vim-markdown
autocmd vimrc FileType markdown packadd mkdx
let g:vim_markdown_folding_disabled = 1
let g:markdown_fenced_languages = [
      \'javascript',
      \'js=javascript',
      \'json=javascript',
      \'java',
      \'css',
      \'sass',
      \'mustache',
      \'html=mustache',
      \'sh',
      \'shell=sh',
      \]
"}}}

" Commands and Mappings {{{
" auto-cd based on file from
" http://inlehmansterms.net/2014/09/04/sane-vim-working-directories/

" follow symlinked file
function! FollowSymlink()
  let l:current_file = expand('%:p')
  " check if file type is a symlink
  if getftype(l:current_file) ==? 'link'
    " if it is a symlink resolve to the actual file path
    "   and open the actual file
    let l:actual_file = resolve(l:current_file)
    silent! execute 'file ' . l:actual_file
  end
endfunction

" set working directory to git project root
" or directory of current file if not git project
function! SetProjectRoot()
  " default to the current file's directory
  cd %:p:h
  let l:git_dir = system('git rev-parse --show-toplevel')
  " See if the command output starts with 'fatal' (if it does, not in a git repo)
  let l:is_not_git_dir = matchstr(l:git_dir, '^fatal:.*')
  " if git project, change local directory to git project root
  if empty(l:is_not_git_dir)
    cd `=l:git_dir`
  endif
endfunction

" RG + FZF
command! -bang -nargs=* Rg
      \ call fzf#vim#grep(
      \   'rg --column --line-number --no-heading --color=always '
      \    . '--hidden --smart-case --fixed-strings '.shellescape(<q-args>), 1,
      \   <bang>0 ? fzf#vim#with_preview('up:60%')
      \           : fzf#vim#with_preview('right:50%:hidden', '?'),
      \   <bang>0)

set grepprg=rg\ --vimgrep
set grepformat^=%f:%l:%c:%m

nnoremap <leader><Space> :<C-U>

nnoremap <leader>vi :<C-U>PackInstall<CR>
nnoremap <leader>vc :<C-U>PackClean<CR>
nnoremap <leader>vr :<C-U>source $MYVIMRC<CR>
nnoremap <leader>ve :<C-U>e $MYVIMRC<CR>

nnoremap <leader>hh :Helptags<CR>
nnoremap <leader>hk :Maps<CR>
nnoremap <leader>hc :Commands<CR>

nnoremap <leader>qq :<C-U>q<CR>
nnoremap <leader>qw :<C-U>wq<CR>
nnoremap <leader>qx :<C-U>x<CR>

" buffers
nnoremap <leader>bb :<C-u>Buffers<CR>
nnoremap <leader>bd :<C-u>Bdelete<CR>
nnoremap <leader>bn ]b
nnoremap <leader>bp [b
" ack/grep
nnoremap <leader>/ :<C-u>Rg<space>
" grep word under cursor
nnoremap <leader>* :<C-u>execute 'Rg ' . expand("<cword>")<CR>
" files
nnoremap <leader>fr :<C-u>History<CR>

command! Ctrlp execute (exists("*fugitive#head") && len(fugitive#head())) ? 'GFiles --exclude-standard --others --cached' : 'Files'
nnoremap <C-p>      :<C-u>Ctrlp<CR>

nnoremap <leader>ff :<C-u>Files<CR>
nnoremap <leader>ftt :NERDTreeToggle<CR>
nnoremap <leader>ftr :NERDTreeRefreshRoot<CR>
nnoremap <leader>ftf :NERDTreeFind<CR>:wincmd p<CR>
nnoremap <leader>ftp :NERDTreeVCS<CR>
nnoremap <leader>ftd :NERDTreeCWD<CR>


nnoremap <leader>gf :<C-u>GFiles<CR>
nnoremap <leader>gF :<C-u>GFiles?<CR>
nnoremap <leader>gtt :<C-u>NERDTreeVCS<CR>
nnoremap <leader>gb :<C-u>Twiggy<CR>
nnoremap <leader>gl :<C-u>Flog<CR>
nnoremap <leader>gs :<C-u>Gina status<CR>
nnoremap <leader>gg :<C-u>Gina<Space>

nnoremap <leader>: :<C-u>Commands<CR>
" search in file
nnoremap // :<C-u>BLines<CR>

nmap <silent> <leader>s :Snippets<CR>

imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-j> <plug>(fzf-complete-file-ag)
imap <c-x><c-l> <plug>(fzf-complete-line)

nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)

" typo corrections
nmap q: :q<cr>

" unmap s, which can easily be replaces by cl
nmap s <Nop>
xmap s <Nop>

nmap <C-j> <C-W>j
nmap <C-k> <C-W>k
nmap <C-h> <C-W>h
nmap <C-l> <C-W>l

nmap <silent> <leader>tc :Color<CR>
nmap <silent> <leader>tf :<C-u>Filetypes<CR>
nmap <silent> <leader>tu :MundoToggle<CR>
nmap <silent> <leader>tr :RainbowParenthesesToggle<CR>

nmap <silent> <leader>rtt :TestNearest<CR>
nmap <silent> <leader>rtf :TestFile<CR>
nmap <silent> <leader>rts :TestSuite<CR>
nmap <silent> <leader>rtr :TestLast<CR>
nmap <silent> <leader>rtv :TestVisit<CR>

nmap <silent> <leader>wq :hide<CR>
nmap <silent> <leader>wd :hide<CR>
nmap <silent> <leader>wj <C-j>j
nmap <silent> <leader>wk <C-k>k
nmap <silent> <leader>wl <C-w>l
nmap <silent> <leader>wh <C-w>h
nmap <silent> <leader>ws :split<CR>
nmap <silent> <leader>wv :vsplit<CR>
nmap <silent> <leader>wz <C-w><T>

nmap <silent> H :bp<CR>
nmap <silent> L :bn<CR>

vnoremap < <gv
vnoremap > >gv

if has('gui_running')
  let g:fontzoom_no_default_key_mappings = 1
  packadd vim-fontzoom
  nmap <silent> <C-ScrollWheelUp>	<Plug>(fontzoom-larger)
  nmap <silent> <leader>+	<Plug>(fontzoom-larger)
  nmap <silent> <leader>=	<Plug>(fontzoom-larger)
  nmap <silent> <C-ScrollWheelDown>	<Plug>(fontzoom-smaller)
  nmap <silent> <leader>-	<Plug>(fontzoom-smaller)
  nmap <silent> <leader>0 :Fontzoom!<cr>
endif

autocmd vimrc FileType netrw call s:filer_settings()

function! s:filer_settings()
  nmap <buffer> q <C-^>
  nmap <buffer> h -
  nmap <buffer> l <CR>
  nmap <buffer> t i
  setlocal bufhidden=wipe
endfunction

autocmd vimrc FileType markdown call s:markdown_mappings()

function! s:markdown_mappings()
  nmap <localleader>tt :call mkdx#ToggleCheckboxState()<Cr>
  vmap <localleader>tt :call mkdx#ToggleCheckboxState()<Cr>:call mkdx#MaybeRestoreVisual()<Cr>
  nmap <localleader>tT :call mkdx#ToggleCheckboxState(1)<Cr>
  vmap <localleader>tT :call mkdx#ToggleCheckboxState(1)<Cr>:call mkdx#MaybeRestoreVisual()<Cr>
  nmap <localleader>tc :call mkdx#ToggleCheckboxTask()<Cr>
  vmap <localleader>tc :call mkdx#ToggleCheckboxTask()<Cr>:call mkdx#MaybeRestoreVisual()<Cr>
  nmap <localleader>tl :call mkdx#ToggleChecklist()<Cr>
  vmap <localleader>tl :call mkdx#ToggleChecklist()<Cr>:call mkdx#MaybeRestoreVisual()<Cr>
endfunction

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

"}}}
