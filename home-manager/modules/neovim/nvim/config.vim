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
if has('mouse_sgr')       " fix mouse in tmux
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

if has('nvim-0.3.2') || has('patch-8.1.0360')
    set diffopt=filler,internal,algorithm:histogram,indent-heuristic
endif
set diffopt-=iwhite       " ignore whitespace when diffing
let &listchars='tab:⇥ ,eol:$,trail:·,extends:>,precedes:<' " set list
let &fillchars='vert:│,fold: '
"}}}

" Completion {{{
set noshowmode shortmess+=c
set noinfercase
set completeopt=menuone,noselect
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
if empty(glob($XDG_DATA_HOME.'/nvim/pack/packager/opt/packager'))
  silent !git clone 'https://github.com/kristijanhusak/vim-packager'
        \ $XDG_DATA_HOME"/nvim/pack/packager/opt/packager"
endif
"}}}
"
" Package commands {{{
command! -bar -nargs=+ Pack call packager#add(<args>)
command! PackInstall call PackagerInit() | call packager#install()
command! -bang PackUpdate call PackagerInit() | call packager#update({ 'force_hooks': '<bang>' })
command! PackClean   call PackagerInit() | call packager#clean()
command! PackStatus  call PackagerInit() | call packager#status()
"}}}

function! PackagerInit() abort
  packadd packager

  " only work with packages after packager is loaded
  call packager#init()

  " Simple Sane QoL Packages {{{
  Pack 'kristijanhusak/vim-packager', { 'type': 'opt', 'name': 'packager' }
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
  Pack 'ConradIrwin/vim-bracketed-paste' " auto-toggle ':set paste' when pasting in terminal
  Pack 'romainl/vim-cool'              " smart :nohl after searching
  "}}}

  " Snippets {{{
  Pack 'SirVer/ultisnips'
  Pack 'honza/vim-snippets'
  " "}}}

  " Completion {{{
  Pack 'neovim/nvim-lspconfig'
  Pack 'hrsh7th/nvim-compe'
  Pack 'nvim-treesitter/nvim-treesitter'
  Pack 'kristijanhusak/vim-dadbod-completion'

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
  Pack 'tpope/vim-dadbod'                              " Modern database interface for Vim
  Pack 'kristijanhusak/vim-dadbod-ui'                  " UI for dadbod
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
  Pack 'kyazdani42/nvim-web-devicons' " nerdfont lua api
  Pack 'akinsho/nvim-bufferline.lua'  " a pretty bufferline
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
  Pack 'jceb/vim-orgmode', {'type': 'opt'}        " orgmode
  Pack 'inkarkat/vim-SyntaxRange', {'type': 'opt'} " for orgmode
  Pack 'nathangrigg/vim-beancount', {'type': 'opt'} " for orgmode
  "}}}
endfunction

"}}}

" Package Settings {{{

" Whichkey {{{
set timeoutlen=500     " speed up whichkey
let g:mapleader = "\<Space>"
let g:leader_map = {}
let g:which_key_fallback_to_native_key = 1
autocmd vimrc VimEnter * call which_key#register(g:mapleader, "g:leader_map")
nmap <silent> <leader>          :<c-u>WhichKey         '<leader>'<CR>
vmap <silent> <leader>          :<c-u>WhichKeyVisual   '<leader>'<CR>

let g:maplocalleader = ','
let g:localleader_map = {}
autocmd vimrc VimEnter * call which_key#register(g:maplocalleader, "g:localleader_map")
nnoremap <silent> <localleader>     :<c-u>WhichKey         '<localleader>'<CR>
vnoremap <silent> <localleader>     :<c-u>WhichKeyVisual   '<localleader>'<CR>
inoremap <silent> <C-,>   <c-\><c-o>:<c-u>WhichKey         '<localleader>'<CR>

let g:leader_map.m = '+localleader'
nnoremap <leader>m        :call feedkeys(g:maplocalleader)<CR>
vnoremap <leader>m        :call feedkeys(g:maplocalleader)<CR>
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
      \   'sh':         ['shfmt'],
      \}
let g:ale_fix_on_save = 1
let g:ale_linters = {'clojure': ['clj-kondo', 'joker']}
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

    let top = '╭' . repeat('─', width - 2) . '╮'
    let mid = '│' . repeat(' ', width - 2) . '│'
    let bot = '╰' . repeat('─', width - 2) . '╯'
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
    au vimrc BufWipeout <buffer> exe 'bw '.s:buf
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
let g:polyglot_disabled = ['yaml', 'markdown']
" }}}

" mkdx {{{
let g:mkdx#settings = {
      \ 'map':                     { 'prefix': ',', 'enable': 1 },
      \ 'tokens':                  { 'enter':  ['-', '*', '>'],
      \                              'bold':   '**', 'italic': '*',
      \                              'strike': '',
      \                              'list':   '-',  'fence':  '',
      \                              'header': '#' },
      \ 'checkbox':                { 'toggles': [' ', '-', 'x'],
      \                              'update_tree': 2,
      \                              'initial_state': ' ' },
      \ 'highlight':               { 'enable': 1 },
      \ 'auto_update':             { 'enable': 1 },
      \ 'fold':                    { 'enable': 1 }
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
let g:paredit_leader=','
let g:paredit_smartjump=1
"}}}

" peekaboo {{{
" let g:peekaboo_window = "vert bo 30new"
let g:peekaboo_delay = 300
let g:peekaboo_compact = 1
" "}}}

" ncm2 {{{
" autocmd vimrc BufEnter * call ncm2#enable_for_buffer()

" func! config#expand_snippet()
"   if ncm2_ultisnips#completed_is_snippet()
"     call feedkeys("\<Plug>(ncm2_ultisnips_expand_completed)", "m")
"   endif
"   return ''
" endfunc
"}}}

" nvim-compe {{{
let g:compe = {}
let g:compe.enabled = v:true

let g:compe.autocomplete = v:true
let g:compe.debug = v:false
let g:compe.min_length = 1
let g:compe.preselect = 'enable'
let g:compe.throttle_time = 80
let g:compe.source_timeout = 200
let g:compe.incomplete_delay = 400

let g:compe.max_abbr_width = 100
let g:compe.max_kind_width = 100
let g:compe.max_menu_width = 100
let g:compe.documentation = v:true

let g:compe.source = {}
let g:compe.source.path = v:true
let g:compe.source.buffer = v:true
let g:compe.source.calc = v:true

let g:compe.source.nvim_lsp = v:true
let g:compe.source.nvim_lua = v:true
let g:compe.source.spell = v:true
let g:compe.source.tags = v:true
let g:compe.source.ultisnips = v:true
let g:compe.source.treesitter = v:true
let g:compe.source.vim_dadbod_completion = v:true
let g:compe.source.omni = v:true

call compe#setup(g:compe)
" }}}

" UltiSnips {{{
let g:UltiSnipsExpandTrigger            = '<Plug>(ultisnips_expand)'
let g:UltiSnipsJumpForwardTrigger       = '<c-j>'
let g:UltiSnipsJumpBackwardTrigger      = '<c-k>'
let g:UltiSnipsRemoveSelectModeMappings = 0
"}}}

" nvim-bufferline.lua {{{
lua <<EOF
require'bufferline'.setup{
  options = {
    view = "multiwindow",
    numbers = "none",
    number_style = "",
    mappings = false,
    buffer_close_icon= '',
    modified_icon = '●',
    close_icon = '',
    left_trunc_marker = '',
    right_trunc_marker = '',
    max_name_length = 18,
    max_prefix_length = 15,
    tab_size = 18,
    diagnostics = "nvim_lsp",
    diagnostics_indicator = function(count, level)
      local icon = level:match("error") and " " or ""
      return " " .. icon .. count
    end,
    show_buffer_close_icons = true,
    persist_buffer_sort = true,
    separator_style = "thick",
    enforce_regular_tabs = true,
    always_show_bufferline = false,
    sort_by = "directory"
  }
}
EOF
" }}}

" Colors {{{
let ayucolor='dark'
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
  if &background ==? 'dark'
    hi Normal       ctermbg=NONE guibg=NONE
    hi LineNr       ctermbg=NONE guibg=NONE
    hi SignColumn   ctermbg=NONE guibg=NONE
    hi FoldColumn   ctermbg=NONE guibg=NONE
    hi CursorLineNr ctermbg=NONE guibg=NONE
    hi VertSplit    ctermbg=NONE guibg=NONE
  endif
endfun

fun! SetTheme()
  if &background ==? 'dark'
    colorscheme gruvbox
  else
    colorscheme PaperColor
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
  autocmd vimrc BufWritePre * :%s/\s\+$//e
endfun

autocmd vimrc FileType markdown let b:noStripWhitespace=1
autocmd vimrc Filetype * call EnableStripTrailingWhitespace()

" Pack 'tomtom/foldtext_vim'
" autocmd vimrc FileType org,tex,latex,markdown,asciidoc packadd foldtext_vim
autocmd vimrc FileType md,markdown,mail setlocal spell
autocmd vimrc BufRead,BufNewFile mail set tw=0
autocmd vimrc BufRead,BufNewFile mail set wrapmargin=3

autocmd vimrc FileType md,markdown,text,mail packadd vim-pencil

autocmd vimrc BufNewFile,BufRead *.md set filetype=markdown
let g:vim_markdown_fenced_languages = [
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

autocmd vimrc BufNewFile,BufRead *.org set filetype=org
autocmd vimrc FileType org packadd vim-SyntaxRange
autocmd vimrc FileType org packadd vim-orgmode

autocmd vimrc BufNewFile,BufRead *.beancount set filetype=beancount
autocmd vimrc FileType beancount packadd vim-beancount
"}}}

" Commands and Mappings {{{

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

" <leader {{{
" <leader>v (vim) {{{
let g:leader_map.v = {'name': '+vim'}
nnoremap <leader>vi :<C-U>PackInstall<CR>
nnoremap <leader>vc :<C-U>PackClean<CR>
nnoremap <leader>vu :<C-U>PackUpdate<CR>
nnoremap <leader>vr :<C-U>source $MYVIMRC<CR>
nnoremap <leader>ve :<C-U>e $MYVIMRC<CR>
" }}}

" <leader>h (help) {{{
let g:leader_map.h = {'name': '+help'}
nnoremap <leader>hh :Helptags<CR>
nnoremap <leader>hk :Maps<CR>
nnoremap <leader>hc :Commands<CR>
" }}}

" <leader>q (quit) {{{
let g:leader_map.q = {'name': '+quit'}
nnoremap <leader>qq :<C-U>q<CR>
nnoremap <leader>qw :<C-U>wq<CR>
nnoremap <leader>qx :<C-U>x<CR>
" }}}

" <leader>b (buffers) {{{
let g:leader_map.b = {'name': '+buffers'}
nnoremap <leader>bb :<C-u>Buffers<CR>
nnoremap <leader>bd :<C-u>Bdelete<CR>
let g:leader_map.b.n = 'next'
nnoremap <leader>bn ]b
let g:leader_map.b.p = 'prev'
nnoremap <leader>bp [b
let g:leader_map.b.N = 'move-next'
nnoremap <leader>bN :<C-u>BufferLineMoveNext<CR>
let g:leader_map.b.P = 'move-prev'
nnoremap <leader>bP :<C-u>BufferLineMovePrev<CR>
"}}}

" <leader>/ (grep) {{{
let g:leader_map['/'] = 'search'
nnoremap <leader>/ :<C-u>Rg<space>
" grep word under cursor
let g:leader_map['*'] = 'search-cur-word'
nnoremap <leader>* :<C-u>execute 'Rg ' . expand("<cword>")<CR>
" }}}

" <leader>f (files) {{{
let g:leader_map.f = {'name': '+files'}
let g:leader_map.f.r = 'recent'
nnoremap <leader>fr :<C-u>History<CR>

nnoremap <leader>ff :<C-u>Files<CR>
let g:leader_map.f.t = {'name': '+toggle'}
nnoremap <leader>ftt :NERDTreeToggle<CR>
nnoremap <leader>ftr :NERDTreeRefreshRoot<CR>
nnoremap <leader>ftf :NERDTreeFind<CR>:wincmd p<CR>
nnoremap <leader>ftp :NERDTreeVCS<CR>
nnoremap <leader>ftd :NERDTreeCWD<CR>
" }}}

" <leader>g (git) {{{
let g:leader_map.g = {'name': '+git'}
let g:leader_map.g.t = {'name': '+toggle'}
nnoremap <leader>gf :<C-u>GFiles<CR>
nnoremap <leader>gF :<C-u>GFiles?<CR>
nnoremap <leader>gtt :<C-u>NERDTreeVCS<CR>
nnoremap <leader>gb :<C-u>Twiggy<CR>
nnoremap <leader>gl :<C-u>Flog<CR>
nnoremap <leader>gs :<C-u>Gstatus<CR>
nnoremap <leader>gg :<C-u>Gina<Space>
" }}}

" <leader>t (toggle)) {{{
let g:leader_map.t = {'name': '+toggle'}
nmap <silent> <leader>tc :Color<CR>
nmap <silent> <leader>tf :<C-u>Filetypes<CR>
nmap <silent> <leader>tu :MundoToggle<CR>
nmap <silent> <leader>tr :RainbowParenthesesToggle<CR>
" }}}

" <leader>r (run) {{{
let g:leader_map.r = {'name': '+run'}
let g:leader_map.r.t = {'name': '+test'}
nmap <silent> <leader>rtt :TestNearest<CR>
nmap <silent> <leader>rtf :TestFile<CR>
nmap <silent> <leader>rts :TestSuite<CR>
nmap <silent> <leader>rtr :TestLast<CR>
nmap <silent> <leader>rtv :TestVisit<CR>
" }}}

" <leader>w (window) {{{
let g:leader_map.w = {'name': '+window'}
nmap <silent> <leader>wq :hide<CR>
nmap <silent> <leader>wd :hide<CR>
nmap <silent> <leader>wj <C-j>j
nmap <silent> <leader>wk <C-k>k
nmap <silent> <leader>wl <C-w>l
nmap <silent> <leader>wh <C-w>h
nmap <silent> <leader>ws :split<CR>
nmap <silent> <leader>wv :vsplit<CR>
nmap <silent> <leader>wz <C-w><T>
"}}}

" <leader>*** (misc) {{{
let g:leader_map[' '] = 'command'
nnoremap <leader><Space> :<C-U>
nnoremap <leader>: :<C-u>Commands<CR>
" search in file
nnoremap // :<C-u>BLines<CR>

nmap <silent> <leader>s :Snippets<CR>

nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)
" }}}
" }}}

command! Ctrlp execute (exists("*fugitive#head") && len(fugitive#head())) ? 'GFiles --exclude-standard --others --cached' : 'Files'
nnoremap <C-p>      :<C-u>Ctrlp<CR>

imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-j> <plug>(fzf-complete-file-ag)
imap <c-x><c-l> <plug>(fzf-complete-line)

let g:endwise_no_mappings = 'plz stahp'
inoremap <silent><expr><C-Space> compe#complete()
inoremap <silent><expr><CR> compe#confirm('<CR>')
inoremap <silent><expr><C-e> compe#close('<C-e>')
inoremap <silent><expr><C-f> compe#scroll({ 'delta': +4 })
inoremap <silent><expr><C-d> compe#scroll({ 'delta': -4 })

" typo corrections
nmap q: :q<cr>

" unmap s, which can easily be replaces by cl
nmap s <Nop>
xmap s <Nop>

nmap <C-j> <C-W>j
nmap <C-k> <C-W>k
nmap <C-h> <C-W>h
nmap <C-l> <C-W>l

nmap <silent> H :bp<CR>
nmap <silent> L :bn<CR>
nmap <silent> [b :BufferLineCyclePrev<CR>
nmap <silent> ]b :BufferLineCycleNext<CR>

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

autocmd vimrc FileType dirvish nmap <buffer> q <Plug>(dirvish_quit)

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

"}}}
