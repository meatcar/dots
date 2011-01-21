" ----------------------------------------------------------------------
" file:     ~/.vimrc
" author:   Thayer Williams - http://cinderwick.ca
" modified: June 21, 2008
" vim:nu:ai:si:et:ts=4:sw=4:ft=vim:
" ----------------------------------------------------------------------

" general --------------------------------------------------------------

set t_Co=256            " enable 256-color support
"colorscheme python      " define syntax color scheme
colorscheme ir_black    "define syntax color scheme
"colorscheme rubyblue   " define syntax color scheme
"colorscheme wombat     " define syntax color scheme
"colorscheme molokai
set nocompatible        " disregard vi compatibility
set dir=~/.vim/swap     " keep swap files in one place
set bdir=~/.vim/backup  " keep backups in one place
set encoding=utf-8      " UTF-8 encoding for all new files
"set fileencoding=utf-8  " force filetype encoding for existing files
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
let g:pydiction_location = '/usr/share/pydiction/complete-dict'
set grepprg=grep\ -nH\ $*

" latex stuff.
let g:tex_flavor = "latex"

" python hiliting ------------------------------------------------------

:let python_highlight_numbers = 1
:let python_highlight_builtins = 1
:let python_highlight_exceptions = 1
:let python_highlight_space_errors = 1
highlight OverLength ctermbg=black
match OverLength /\%>79v.\+/


" html conversion (:help 2html.vim) ------------------------------------

let g:html_use_css = 1
let g:use_xhtml = 1
let g:html_use_encoding = "utf8"
let g:html_number_lines = 1
set runtimepath=~/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,~/.vim/after

" statusline -----------------------------------------------------------

set cmdheight=1         " command line height
set laststatus=2        " condition to show status line, 2=always.
set ruler               " show cursor position in status line
set showmode            " show mode in status line
set showcmd             " show partial commands in status line
" left: fileformat, filetype, fileencoding, RO/HELP/PREVIEW, modified flag filepath
" right: buffer num, lines/total, cols/virtual, display percentage
set statusline=%([%{&ff}]%)%(:[%{&fenc}]%)%(:%y%)\ \ %r%h%w\ %#Error#%m%#Statusline#\ %F\ %=buff[%1.3n]\ \ %1.7l/%L,%1.7c%V\ \ [%P]\


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


" hotkeys --------------------------------------------------------------

" typo corrections
nmap q: :q<cr>

" enter ex mode with a semi-colon too
nnoremap ; :
vnoremap ; :

" C-s to save
inoremap <C-s> <esc>:w<cr>a
nnoremap <C-s> :w<cr>

" F2 selects all
"nnoremap <F2> ggVG

" F3 toggles wordwrap
"nnoremap <F3> :set invwrap wrap?<CR>

" F5 toggles paste mode
"set pastetoggle=<F5>

" F6 toggles spell checking
"map <F6> :setlocal spell! spelllang=en_ca<cr>
"imap <F6> <C-o>:setlocal spell! spelllang=en_ca<cr>

" F9 runs 2html conversion
"map :runtime syntax/2html.vim

" strip ^M linebreaks from dos formatted files
map M :%s/
"$//g


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
        set guifont=Dina\ 9     " backslash any spaces
        "set guioptions-=T      "hide the toolbar
        colorscheme evening 
        set columns=118         "previous values: 120
        set lines=40            "previous values: 40, 32
    endif
endif

" HACK: I don't want a .gvimrc but some stuff gets reset during GUI init,
" therefore re-source .vimrc at GUI start
if has("gui")
    "autocmd GUIEnter * source <sfile>
endif


" autocmd rules --------------------------------------------------------

if has("autocmd")
    au BufRead,BufNewFile PKGBUILD set ft=sh
    "autocmd BufRead *.txt set tw=78             " limit width to n cols for txt files
    "autocmd BufRead /tmp/mutt-* set tw=72 ft=mail nocindent spell  " width, mail syntax hilight, spellcheck
    " always jump to the last cursor position
    autocmd BufReadPost * if line("'\"")>0 && line("'\"")<=line("$")|exe "normal g`\""|endif

    " experimental stuff
    "au FileType css setlocal ofu=csscomplete#CompleteCSS    " ala phrak
    "
    "remove trailing whitespace in python files upon save
    autocmd BufWritePre *.py normal m`:%s/\s\+$//e ``
endif

" PYTHON-VIM  -----------------------------------------------------------

" tasklist.vim
map T :TaskList<CR>
map P :TlistToggle<CR>

autocmd FileType python set omnifunc=pythoncomplete#Complete
