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

" enable undercurls
let &t_Cs = "\e[4:3m"
let &t_Ce = "\e[4:0m"

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
  set breakindentopt=shift:2,list:-1,min:30
  let &showbreak='↳ '
  set cpoptions+=n
endif

set splitbelow            " place the new split below the current file
set splitright            " place the new split to the right of the current file
set previewheight=9       " default height for a preview window (def:12)

set wildmode=longest,list:longest

if has('nvim')
  set pumblend=50           " neovim popup window blend
  hi PmenuSel blend=0
endif

if has('nvim-0.3.2') || has('patch-8.1.0360')
    set diffopt=filler,internal,algorithm:histogram,indent-heuristic
endif
set diffopt-=iwhite       " ignore whitespace when diffing
let &listchars='tab:⇥ ,eol:$,trail:·,extends:>,precedes:<' " set list
let &fillchars='vert:│'
"}}}

" Completion {{{
set noshowmode shortmess+=c
set noinfercase
set completeopt=menu,menuone,noselect
"}}}

" Folds {{{
set viewoptions=cursor,folds " save folds, cursor position
set foldopen+=insert,jump
" Remember Folds
autocmd vimrc BufWinLeave ?* mkview
autocmd vimrc BufWinEnter ?* silent! loadview
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

" Show Cursorline only in the focused window {{{
autocmd vimrc WinEnter,BufEnter * setlocal cursorline
autocmd vimrc WinLeave,BufLeave * setlocal nocursorline
" }}}

" Leader Keys {{{
set timeoutlen=500     " speed up whichkey
let g:mapleader = "\<Space>"
let g:maplocalleader = ','
" }}}

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

" Colors {{{
" Fix old themes colouring SignColumn an ugly grey:
autocmd vimrc ColorScheme *
      \  hi clear SignColumn
      \| hi! link SignColumn LineNr
"}}}

" Filetypes, Syntaxes, and AutoCMDs {{{

autocmd vimrc FileType help setlocal buflisted
autocmd vimrc FileType fish compiler fish
autocmd vimrc BufRead,BufNewFile PKGBUILD set filetype=sh
autocmd vimrc BufRead,BufNewFile .envrc set filetype=sh
autocmd vimrc BufRead,BufNewFile .env set filetype=sh

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
autocmd vimrc FileType md,markdown,mail setlocal spell
autocmd vimrc BufRead,BufNewFile mail set tw=0
autocmd vimrc BufRead,BufNewFile mail set wrapmargin=3

autocmd vimrc BufRead,BufNewFile *.tl set filetype=teal

autocmd vimrc BufRead,BufNewFile *.nix set filetype=nix

autocmd vimrc BufRead,BufNewFile *.heex set filetype=heex
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

" typo corrections
nmap q: <Cmd>q<cr>
"
" nmap <C-j> <C-W>j
" nmap <C-k> <C-W>k
" nmap <C-h> <C-W>h
" nmap <C-l> <C-W>l

nmap <silent> H [b
nmap <silent> L ]b
vnoremap < <gv
vnoremap > >gv

autocmd vimrc FileType netrw call s:filer_settings()
function! s:filer_settings()
  " improve netrw a-la tpope/vim-vinegar
  nmap <buffer> q <C-^>
  nmap <buffer> h -
  nmap <buffer> l <CR>
  nmap <buffer> t i
  setlocal bufhidden=wipe
endfunction

" Terminal setup
function! s:term(bang, rest)
  " use $SHELL, not &shell, pass on any args
  execute 'terminal'
              \ . (a:bang?'!':'')
              \ . ' ' . $SHELL
              \ . (empty(a:rest)?'':' -c "' . a:rest . '"')
  " execute 'normal i'
endfunction
command! -nargs=* -bang -complete=shellcmd Term call s:term(<bang>0, <q-args>)
autocmd vimrc TermOpen term://* startinsert " start in insert mode
autocmd vimrc TermClose term://* bdelete! " close terminal right away
" get back to normal mode quickly
tnoremap <Esc><Esc> <C-\><C-n>
"}}}

" Lua {{{
lua require('init')
" }}}
