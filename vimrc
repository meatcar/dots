" ----------------------------------------------------------------------
" file:     ~/.vimrc
" author:   Denys Pavlov
" modified: January 15, 2011
" vim:nu:ai:si:et:ts=4:sw=4:ft=vim:
" ----------------------------------------------------------------------

" general --------------------------------------------------------------

set t_Co=256            " enable 256-color support
set title
set nocompatible        " disregard vi compatibility:
set runtimepath+=~/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,~/.vim/after
set dir=~/.vim/swap,/tmp     " keep swap files in one place
set bdir=~/.vim/backup,/tmp  " keep backups in one place
set undodir=~/.vim/undo,/tmp " keep undos in one place
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
set shell=/bin/sh       " set default shell type
set previewheight=9     " default height for a preview window (def:12)
"set textwidth=79       " insert carriage return after n cols wide
syntax on               " enable syntax highlighting
filetype plugin indent on   " enable filetype-sensitive plugins and indenting
set grepprg=grep\ -nH\ $*
set wildmenu
set wildmode=list:longest
set hidden              " un-saved buffers in the background
set cc=80
set laststatus=2        " show the status bar even when editing one file.

set diffopt-=iwhite
set listchars=tab:>-,trail:-

" tabs and indenting ---------------------------------------------------

set expandtab           " insert spaces instead of tabs
set tabstop=4           " n space tab width
set shiftwidth=4        " allows the use of < and > for VISUAL indenting
set softtabstop=4       " counts n spaces when DELETE or BCKSPCE is used
set smarttab            " set <Tab>s according to shiftwidth
set autoindent          " auto indents next new line
set nocindent           " C style indenting off
set formatoptions=tcqr  " recommended defaults from O'Reilly

" searching ------------------------------------------------------------

set hlsearch            " highlight all search results
set incsearch           " increment search
set ignorecase          " case-insensitive search
set smartcase           " uppercase causes case-sensitive search
set wrapscan            " searches wrap back to the top of file
runtime macros/matchit.vim  " extend the % key

" Vundle stuff ---------------------------------------------------------

call plug#begin('~/.vim/bundle')

Plug 'tpope/vim-sensible'

" colorschemes
Plug 'flazz/vim-colorschemes'

Plug 'surround.vim'
Plug 'repeat.vim'
Plug 'tpope/vim-fugitive'
Plug 'jaxbot/github-issues.vim' " Github issue lookup in Vim
Plug 'tpope/vim-rhubarb'
Plug 'scrooloose/nerdcommenter'
Plug 'bling/vim-airline'
Plug 'ervandew/supertab'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-unimpaired'
Plug 'airblade/vim-gitgutter'
Plug 'wting/gitsessions.vim'
Plug 'PotatoesMaster/i3-vim-syntax'
Plug 'Raimondi/delimitMate'
Plug 'scrooloose/syntastic'
Plug 'trapd00r/irc.vim' " syntax file for irc logs

Plug 'Shougo/vimproc.vim', { 'do' : 'make -f make_unix.mak' }
Plug 'Shougo/unite.vim'
Plug 'Shougo/neomru.vim'
Plug 'Shougo/vimfiler.vim'

Plug 'freitass/todo.txt-vim'

Plug 'WebAPI.vim'
Plug 'Gist.vim', {'on': 'Gist'}

Plug 'Gundo', {'on': 'GundoToggle'}
Plug 'ack.vim', {'on': 'Ack'}

" filetype-dependent bundles
Plug 'xml.vim', {'for': 'xml'}
Plug 'nono/vim-handlebars', {'for': ['html', 'hbs']}
Plug 'Markdown', {'for': 'markdown'}
Plug 'Markdown-syntax', {'for': 'markdown'}
Plug 'groenewege/vim-less', {'for': 'less'}
Plug 'less.vim', {'for': 'less'}
Plug 'skammer/vim-css-color', {'for': ['css', 'less']}
Plug 'digitaltoad/vim-jade', {'for': 'jade'}
Plug 'TeX-9', {'for': ['tex', 'latex']}
Plug 'mattn/emmet-vim', {'for': ['html', 'xml']} " emmet for vim: http://emmet.io/
Plug 'beyondmarc/glsl.vim', {'for': 'glsl'} " OpenGL Shading Language (GLSL) Vim syntax highlighting
Plug 'sealemar/vtl', {'for': 'velocity'} " velocity syntax for vim
Plug 'dln/avro-vim', {'for': 'avro-idl'}

Plug 'edkolev/erlang-motions.vim', {'for': 'erlang'}
Plug 'jimenezrick/vimerl', {'for': 'erlang'}

call plug#end()

" Signify settings -----------------------------------------------------------

let g:signify_vcs_list = [ 'git' ]

" Airline settings -----------------------------------------------------------

let g:airline_theme='understated'

" Syntastic settings ---------------------------------------------------------

let g:syntastic_check_on_open=1
let g:syntastic_auto_loc_list=1
let g:syntastic_loc_list_height=3

" These are the tweaks I apply to YCM's config, you don't need them but they might help.
" YCM gives you popups and splits by default that some people might not like, so these should tidy it up a bit for you.
let g:ycm_add_preview_to_completeopt=0
let g:ycm_confirm_extra_conf=0
set completeopt-=preview

" latex stuff. ---------------------------------------------------------
"
"let g:tex_flavor = 'pdflatex'
"let g:tex_viewer = {'app': 'zathura', 'target': 'pdf'}
"let g:Tex_ViewRule_pdf = 'zathura'
"let g:Tex_DefaultTargetFormat = 'pdf'
    " Old school LaTeX user
let g:tex_nine_config = {
    \'compiler': 'pdflatex',
    \'viewer': {'app':'zathura', 'target':'pdf'}
\}

" colorscheme -----------------------------------------------------------
"
let g:zenesque_colors=2
let g:solarized_italic=0 " disable italics for solarized. They look ugly.
if has ("gui_running")
  colorscheme github "define syntax color scheme
else
  colorscheme github
endif

" gist settings --------------------------------------------------------

let g:gist_clip_command = 'xclip -selection clipboard'
let g:gist_detect_filetype = 1
let g:gist_open_browser_after_post = 1
let g:gist_browser_command = 'google-chrome %URL% &'


" cursorcross settings -----------------------------------------------
let g:cursorcross_dynamic = "clw"


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

" airline statusline config --------------------------------------------

let g:airline_powerline_fonts=1
let g:airline_enable_syntastic=1
let g:airline#extensions#branch#enabled = 1

" gvim settings --------------------------------------------------------

if has ("gui_running")
    set lsp=0             "set linespacing"
    set guifont=Inconsolata\ 12 "set the font
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

    "remove trailing whitespace upon save
    autocmd FileType javascript,python,tex,java autocmd BufWritePre * :%s/\s\+$//e

    " web-coding stuff
    au BufNewFile,BufRead *.less set filetype=less
    au BufNewFile,BufRead *.md set filetype=markdown
    au BufNewFile,BufRead *.glsl set filetype=glsl
    au BufNewFile,BufRead *.erl,*.es,*.hrl,*.yaws,*.xrl setf erlang
    au BufRead,BufNewFile *.avdl setlocal filetype=avro-idl

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
" set fuzzy matcher
call unite#custom_source('file,file/new,buffer,file_rec,file_rec/async,file_mru,directory,directory_mru',
      \'matchers', [ 'converter_relative_word',  'matcher_fuzzy'])
call unite#custom_source('file,file/new,buffer,file_rec,file_rec/async,file_mru,directory,directory_mru',
      \'sorters', ['sorter_rank'])
call unite#custom_source('file,file/new,buffer,file_rec,file_rec/async,file_mru,directory,directory_mru',
      \'converters', [ 'converter_relative_abbr' ])

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
" disable netrw.vim
let g:loaded_netrwPlugin = 1
let g:vimfiler_as_default_expolorer = 1
nno ` :<C-u>:VimFilerBufferDir -buffer-name=explorer -status<CR>

function! s:vimfiler_settings()
  nmap <buffer> ` <Plug>(vimfiler_exit)
endfunction

" Go into directory or file under the cursor.
autocmd FileType vimfiler nmap  <silent><buffer><expr> <CR> vimfiler#smart_cursor_map(
    \ "\<Plug>(vimfiler_execute)", 
    \ "\<Plug>(vimfiler_edit_file)")
autocmd FileType vimfiler nmap  <silent><buffer><expr> l vimfiler#smart_cursor_map(
    \ "\<Plug>(vimfiler_execute)", 
    \ "\<Plug>(vimfiler_edit_file)")

autocmd UniteAutoCmd Filetype vimfiler call s:vimfiler_settings()

" hotkeys --------------------------------------------------------------

" typo corrections
nmap q: :q<cr>
command BW :b#|:bw#     " easier buffer closing
command SO :so ~/.vimrc " easier buffer closing

nmap <C-j> <C-W>j
nmap <C-k> <C-W>k
nmap <C-h> <C-W>h
nmap <C-l> <C-W>l

nmap <silent> <leader>g :GundoToggle<CR>

nmap H gT
nmap L gt

