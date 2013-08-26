" ----------------------------------------------------------------------
" file:     ~/.vimrc
" author:   Denys Pavlov
" modified: January 15, 2011
" vim:nu:ai:si:et:ts=4:sw=4:ft=vim:
" ----------------------------------------------------------------------

" general --------------------------------------------------------------

set t_Co=256            " enable 256-color support
set nocompatible        " disregard vi compatibility:
set dir=~/.vim/swap,/tmp     " keep swap files in one place
set bdir=~/.vim/backup,/tmp  " keep backups in one place
set undodir=~/.vim/undo,/tmp " keep undos in one place
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
set previewheight=9     " default height for a preview window (def:12)
"set textwidth=79       " insert carriage return after n cols wide
syntax on               " enable syntax highlighting
filetype plugin indent on   " enable filetype-sensitive plugins and indenting
set grepprg=grep\ -nH\ $*
set wildmenu
set wildmode=list:longest
set hidden              " un-saved buffers in the background
set cc=80
set encoding=utf-8
set laststatus=2        " show the status bar even when editing one file.

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
runtime macros/matchit.vim  " extend the % key

" Vundle stuff ---------------------------------------------------------
call vundle#rc()
 " let Vundle manage Vundle
 " required!
Bundle 'gmarik/vundle'

" colorschemes
Bundle 'flazz/vim-colorschemes'

Bundle 'Markdown'
Bundle 'Markdown-syntax'
Bundle 'surround.vim'
Bundle 'repeat.vim'
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-rhubarb'
Bundle 'xml.vim'
Bundle 'TeX-9'
Bundle 'scrooloose/nerdcommenter'
Bundle 'digitaltoad/vim-jade'
"Bundle 'Lokaltog/vim-powerline'
Bundle 'bling/vim-airline'
Bundle 'ervandew/supertab'
Bundle 'Gundo'
Bundle 'groenewege/vim-less'
Bundle 'less.vim'
Bundle 'skammer/vim-css-color'
Bundle 'nono/vim-handlebars'
Bundle 'ack.vim'
"Bundle 'ctrlp.vim'
Bundle 'Syntastic'
Bundle 'tpope/vim-sleuth'
Bundle 'tpope/vim-unimpaired'
Bundle 'airblade/vim-gitgutter'
Bundle 'wting/gitsessions.vim'
Bundle 'Shougo/unite.vim'
Bundle 'Shougo/vimfiler.vim'
Bundle 'nathanaelkane/vim-indent-guides'
" required for Gist.vim
Bundle 'WebAPI.vim'
Bundle 'Gist.vim'


" Syntastic settings ---------------------------------------------------------

let g:syntastic_check_on_open=1
let g:syntastic_auto_loc_list=1
let g:syntastic_loc_list_height=3


" latex stuff. ---------------------------------------------------------
"
let g:tex_flavor = 'pdflatex'
let g:tex_viewer = {'app': 'zathura', 'target': 'pdf'}
let g:Tex_ViewRule_pdf = 'zathura'
let g:Tex_DefaultTargetFormat = 'pdf'

" indent highlights ----------------------------------------------------

"let g:indent_guides_color_change_percent = 3
  "let g:indent_guides_enable_on_vim_startup = 1

" colorscheme -----------------------------------------------------------
"
colorscheme github "define syntax color scheme
let g:solarized_italic=0 " disable italics for solarized. They look ugly.

" gist settings --------------------------------------------------------

let g:gist_clip_command = 'xclip -selection clipboard'
let g:gist_detect_filetype = 1
let g:gist_open_browser_after_post = 1
let g:gist_browser_command = 'google-chrome %URL% &'

" ctrl-p settings ------------------------------------------------------
let g:ctrlp_user_command = {
\ 'types': {
  \ 1: ['.git/', 'cd %s && git ls-files'],
  \ },
\ 'fallback': ''
\ }
let g:ctrlp_match_window_bottom = 0
let g:ctrlp_match_window_reversed = 0
let g:ctrlp_custom_ignore = '\v\~$|\.(o|swp|pyc|wav|mp3|ogg|blend)$|(^|[/\\])\.(hg|git|bzr)($|[/\\])|__init__\.py'
let g:ctrlp_working_path_mode = 0
let g:ctrlp_dotfiles = 0
let g:ctrlp_switch_buffer = 0
" hotkeys --------------------------------------------------------------

" typo corrections
nmap q: :q<cr>
command BW :b#|:bw#     " easier buffer closing
command SO :so ~/.vimrc " easier buffer closing

" enter ex mode with a semi-colon too
nnoremap ; :
vnoremap ; :

" easier window browsing
map <M-j> <C-W>j<C-W>_
map <M-k> <C-W>k<C-W>_
map <M-h> <C-W>h<C-W>_
map <M-l> <C-W>l<C-W>_

map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" Arrow keys for buffer switching
nnoremap <left> :bprev<cr>
nnoremap <right> :bnext<cr>
nnoremap <down> :buffer #<cr>
nnoremap <up> :buffers<cr>:buffer<space>

nmap <silent> <C-n> :NERDTreeToggle<CR>
nmap <silent> <C-g> :GundoToggle<CR>

nmap H gT
nmap L gt

nmap <silent> <C-p> :CtrlPLastMode<CR>

" airline statusline config --------------------------------------------

let g:airline_powerline_fonts=1
let g:airline_enable_syntastic=1
let g:airline_theme='solarized'

" gvim settings --------------------------------------------------------

if has ("gui_running")
    set guifont=Terminus\ 9 "set the font
    set guioptions-=T      "hide the toolbar
    set guioptions-=m      "hide the manubar
endif

" autocmd rules --------------------------------------------------------

if has("autocmd")
    au BufRead,BufNewFile PKGBUILD set ft=sh
    " always jump to the last cursor position
    autocmd BufReadPost *
                \ if line("'\"")>0 && line("'\"")<=line("$") |
                \   exe "normal g`\"" |
                \ endif

    "remove trailing whitespace in python files upon save
    function TrimWhiteSpace()
      %s/\s*$//
      ''
    :endfunction
    autocmd FileType javascript,python autocmd BufWritePre * :%s/\s\+$//e

    " web-coding stuff
    au BufNewFile,BufRead *.less set filetype=less
    au BufNewFile,BufRead *.md set filetype=markdown

     "Set up omnicompletion
    "if exists("+omnifunc")
        "autocmd Filetype *
                    "\ if &omnifunc == "" |
                    "\   setlocal omnifunc=syntaxcomplete#Complete |
                    "\ endif
    "endif
endif

" Unite ------------------------------------------------------------
augroup UniteAutoCmd
    autocmd!
augroup END
"call unite#custom_source('file,file/new,buffer,file_rec,file_rec/async,file_mru,directory,directory_mru',
      "\'matchers', 'matcher_fuzzy')     " set fuzzy mactcher
call unite#custom_source('file,file/new,buffer,file_rec,file_rec/async,file_mru,directory,directory_mru',
      \'filters', ['sorter_rank', 'converter_relative_word', 'converter_relative_abbr', 'matcher_fuzzy'])     " set fuzzy mactcher
call unite#custom_source('file,file/new,buffer,file_rec,file_rec/async,file_mru,directory,directory_mru',
      \'ignore_pattern', 'node_modules') " ignore node modules"
let g:unite_data_directory = expand('~/.vim/tmp/unite/')
let g:unite_source_process_enable_confirm = 1
let g:unite_source_history_yank_enable = 1
let g:unite_enable_split_vertically = 0
let g:unite_winheight = 20
let g:unite_source_directory_mru_limit = 300
let g:unite_source_file_mru_limit = 300
let g:unite_source_file_mru_filename_format = ':~:.'
let g:unite_source_grep_command = 'ack'
let g:unite_source_grep_default_opts = '--column --no-color --nogroup --with-filename'
let g:unite_source_grep_recursive_opt = ''
nno <leader>a :<C-u>Unite grep -default-action=above<CR>
nno <leader>A :<C-u>execute 'Unite grep:.::' . expand("<cword>") . ' -default-action=above -auto-preview'<CR>
nno <leader>b :<C-u>Unite buffer -buffer-name=buffers -start-insert -no-split -toggle<CR>
"nno <leader><leader> :<C-u>UniteWithCurrentDir buffer file -buffer-name=united -start-insert<CR>
nno <leader>ps :<C-u>:Unite process -buffer-name=processes -start-insert<CR>
nno <leader>u :<C-u>Unite<space>
nno <C-p> :<C-u>:Unite history/yank -buffer-name=yanks<CR>
nno // :<C-u>:Unite line -buffer-name=lines -start-insert -direction=botright -winheight=10<CR>
function! s:unite_settings()
    map <buffer> <leader> <Esc><leader>
endfunction
autocmd UniteAutoCmd FileType unite call s:unite_settings()

" wimviki replacement ----------------------------------------
map <leader>W :<C-u>Unite file file/new -buffer-name=notes -start-insert
      \ -toggle -default-action=split -profile-name=files
      \ -input=<CR>

" ctrl-p replacement --------------------------------------------

nno <leader>t :<C-u>Unite file_rec/async -start-insert -buffer-name=files -no-split<CR>
nno <leader>cd :<C-u>Unite directory_mru directory -start-insert -buffer-name=cd -default-action=cd<CR>

" VimFiler ------------------------------------------------------------
let g:vimfiler_data_directory = expand('~/.vim/tmp/vimfiler/')
let g:vimfiler_safe_mode_by_default = 0
let g:vimfiler_execute_file_list = { "_": "vim" }
nno ` :<C-u>:VimFilerBufferDir -buffer-name=explorer -status<CR>
function! s:vimfiler_settings()
  nmap <buffer> ` <Plug>(vimfiler_exit)
endfunction
autocmd UniteAutoCmd Filetype vimfiler call s:vimfiler_settings()
