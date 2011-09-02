" ----------------------------------------------------------------------
" file:     ~/.vimrc
" author:   Thayer Williams - http://cinderwick.ca
" modified: June 21, 2008
" vim:nu:ai:si:et:ts=4:sw=4:ft=vim:
" ----------------------------------------------------------------------

" general --------------------------------------------------------------

set t_Co=256            " enable 256-color support
colorscheme molokai     "define syntax color scheme
set nocompatible        " disregard vi compatibility:
set dir=~/.vim/swap     " keep swap files in one place
set bdir=~/.vim/backup  " keep backups in one place
set runtimepath=~/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,~/.vim/after,~/.vim/bundle/vundle
set encoding=utf-8      " UTF-8 encoding for all new files
set termencoding=utf-8  " force terminal encoding
set mouse=a             " allow mouse input in all modes
set ttymouse=xterm2     " enable scrolling within screen sessions (MUST HAVE)
set backspace=2         " full backspacing capabilities (indent,eol,start)
set history=100         " 100 lines of command line history
set number              " show line numbers
set numberwidth=1       " minimum num of cols to reserve for line numbers
set nobackup            " disable backup files (filename~)
set showmatch           " show matching brackets (),{},[]
set ww=h,l,<,>,[,]      " whichwrap -- left/right keys can traverse up/down
set wrap                " wrap long lines to fit terminal width
set ttyfast             " tell vim we're using a fast terminal for redraws
set autoread            " reload file if vim detects it changed elsewhere
set wildmenu            " enhanced tab-completion shows all matching cmds
set splitbelow          " place the new split below the current file
set autowrite           " write file if modified on each :next, :make, etc.
set writebackup         " make a backup before writing a file until successful
set shell=/bin/zsh       " set default shell type
set previewheight=5     " default height for a preview window (def:12)
"set textwidth=79       " insert carriage return after n cols wide
syntax on               " enable syntax highlighting
filetype plugin indent on   " enable filetype-sensitive plugins and indenting
set grepprg=grep\ -nH\ $*

" tabs and indenting ---------------------------------------------------

set expandtab           " insert spaces instead of tabs
set tabstop=4           " n space tab width
set shiftwidth=4        " allows the use of < and > for VISUAL indenting
set softtabstop=4       " counts n spaces when DELETE or BCKSPCE is used
set smarttab            " set <Tab>s according to shiftwidth
set autoindent          " auto indents next new line
set nosmartindent       " intelligent indenting -- DEPRECATED by cindent
set nocindent           " C style indenting off
set cinoptions=:0,p0,t0 " recommended defaults from O'Reilly
set cinwords=if,else,while,do,for,switch,case   " recommended defaults from O'Reilly
set formatoptions=tcqr  " recommended defaults from O'Reilly

" searching ------------------------------------------------------------

set hlsearch            " highlight all search results
set incsearch           " increment search
set ignorecase          " case-insensitive search
set smartcase           " uppercase causes case-sensitive search
set wrapscan            " searches wrap back to the top of file

" Vundle stuff ---------------------------------------------------------
call vundle#rc()
 " let Vundle manage Vundle
 " required! 
Bundle 'gmarik/vundle'
Bundle 'molokai'
Bundle 'Markdown'
Bundle 'Markdown-syntax'
Bundle 'LaTeX-Help'
Bundle 'LaTeX-Suite-aka-Vim-LaTeX'
Bundle 'snipmate-snippets'
Bundle 'surround.vim'
Bundle 'repeat.vim'
Bundle 'EasyMotion'
Bundle 'fugitive.vim'

" key-bindings --------------------------------------------------------
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l


" latex stuff. ---------------------------------------------------------
"
let g:tex_flavor = "latex"

" c stuff. ------------------------------------------------------------
"
if has("cscope")
    set csprg=/usr/bin/cscope
    set csto=0
    set cst
    set nocsverb
    " add any database in current directory
    if filereadable("cscope.out")
        cs add cscope.out
    " else add database pointed to by environment
    elseif $CSCOPE_DB != ""
        cs add $CSCOPE_DB
    endif
    set csverb
endif


" statusline -----------------------------------------------------------

set cmdheight=1         " command line height
set laststatus=2        " condition to show status line, 2=always.
set ruler               " show cursor position in status line
set showmode            " show mode in status line
set showcmd             " show partial commands in status line

set statusline=
set statusline +=%1*\ %n\ %*            "buffer number
set statusline +=%5*%{&ff}%*            "file format
set statusline +=%3*%y%*                "file type
set statusline +=%4*\ %<%F%*            "full path
set statusline +=%2*%m%*                "modified flag
set statusline +=%1*%=%5l%*             "current line
set statusline +=%2*/%L%*               "total lines
set statusline +=%1*%4c\ %*             "column number
set statusline +=%2*0x%04B\ %*          "character under cursor
hi User1 guifg=#eea040 guibg=#222222
hi User2 guifg=#dd3333 guibg=#222222
hi User3 guifg=#ff66ff guibg=#222222
hi User4 guifg=#a0ee40 guibg=#222222
hi User5 guifg=#eeee40 guibg=#222222

" hotkeys --------------------------------------------------------------

" typo corrections
nmap q: :q<cr>

" enter ex mode with a semi-colon too
nnoremap ; :
vnoremap ; :

" strip ^M linebreaks from dos formatted files
map M :%s/

" firefox style tabbing ------------------------------------------------

nmap <c-t> :tabnew<cr>
" nmap <c-w> :close<cr>
map <S-h> gT
map <S-l> gt
map <a-1> 1gt
map <a-2> 2gt
map <a-3> 3gt
map <a-4> 4gt
map <a-5> 5gt
map <a-6> 6gt
map <a-7> 7gt
map <a-8> 8gt
map <a-9> 9gt
map <a-0> 10gt

" highlight extra whitespace and tabs ----------------------------------

"highlight RedundantSpaces ctermbg=red guibg=red`
"match RedundantSpaces /\s\+$\| \+\ze\t\|\t/

" gvim settings --------------------------------------------------------

if has ("gui_running")
    " only initialize window size if has not been initialized yet
    if !exists ("s:my_windowInitialized_variable")
        let s:my_windowInitialized_variable=1
        set guifont=Monaco:h8:cANSI "set the font
        set guioptions-=T      "hide the toolbar
        "colorscheme evening 
        "set columns=118         "previous values: 120
        "set lines=40            "previous values: 40, 32
    endif
endif

" autocmd rules --------------------------------------------------------

if has("autocmd")
    au BufRead,BufNewFile PKGBUILD set ft=sh
    " always jump to the last cursor position
    autocmd BufReadPost * if line("'\"")>0 && line("'\"")<=line("$")|exe "normal g`\""|endif

    "remove trailing whitespace in python files upon save
    autocmd BufWritePre *.py normal m`:%s/\s\+$//e ``
endif
