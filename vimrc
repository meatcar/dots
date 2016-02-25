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

if &shell =~# 'fish$'
    set shell=sh      " fish is messed
elseif has('unix')
    set shell=/bin/sh " zsh colors are messed
endif

set runtimepath+=~/dots/vim,"$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,~/dots/vim/after
set dir=~/dots/vim/tmp/swap     " keep swap files in one place
set backupdir=~/dots/vim/tmp/backup " keep backups in one place
set undodir=~/dots/vim/tmp/undo " keep undos in one place
set viewdir=~/dots/vim/tmp/view " keep views in one place
let &viminfo="'100,n".expand('~/dots/vim/tmp/viminfo')
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
set whichwrap=h,l,<,>,[,]      " whichwrap -- left/right keys can traverse up/down
set wrap                " wrap long lines to fit terminal width
set ttyfast             " tell vim we're using a fast terminal for redraws
set autoread            " reload file if vim detects it changed elsewhere
set wildmenu            " enhanced tab-completion shows all matching cmds
set splitbelow          " place the new split below the current file
set autowrite           " write file if modified on each :next, :make, etc.
set writebackup         " make a backup before writing a file until successful
set previewheight=9     " default height for a preview window (def:12)
"set textwidth=79       " insert carriage return after n cols wide
syntax on               " enable syntax highlighting
filetype plugin indent on   " enable filetype-sensitive plugins and indenting
set grepprg=grep\ -nH\ $*
set wildmenu
set wildmode=longest,list:longest
set hidden              " un-saved buffers in the background
set colorcolumn=80
set laststatus=2        " show the status bar even when editing one file.
set cursorline

set diffopt-=iwhite     " ignore whitespace when diffing
let &listchars='tab:⇥ ,eol:$,trail:·,extends:>,precedes:<'    " set list
let &fillchars='vert:│,fold: '

" folds ----------------------------------------------------------------
set foldmethod=syntax
set viewoptions=cursor,folds,slash,unix " save folds, cursor position

function! NeatFoldText()
     "get first non-blank line
     let fs = v:foldstart
     while getline(fs) =~ '^\s*$' | let fs = nextnonblank(fs + 1)
     endwhile
     if fs > v:foldend
         let line = getline(v:foldstart)
     else
         let line = substitute(getline(fs), '\t', repeat(' ', &tabstop), 'g')
     endif

     let w = winwidth(0) - &foldcolumn - (&number ? 8 : 0)
     let foldSize = 1 + v:foldend - v:foldstart
     let foldSizeStr = " " . foldSize . " lines "
     let foldLevelStr = repeat(" ╢", v:foldlevel).' '.v:foldlevel
     let lineCount = line("$")
     let foldPercentage = printf("[%.1f", (foldSize*1.0)/lineCount*100) . "%] "
     let expansionString = repeat(".", w - strwidth(foldSizeStr.line.foldLevelStr.foldPercentage))
     return line . expansionString . foldSizeStr . foldPercentage . foldLevelStr
endfunction
set foldtext=NeatFoldText()

" tabs and indenting ---------------------------------------------------

set expandtab           " insert spaces instead of tabs
set tabstop=4           " n space tab width
set shiftwidth=4        " allows the use of < and > for VISUAL indenting
set softtabstop=4       " counts n spaces when DELETE or BCKSPCE is used
set smarttab            " set <Tab>s according to shiftwidth
set autoindent          " auto indents next new line
set nocindent           " C style indenting off
set formatoptions=tcqr  " recommended defaults from O'Reilly
if exists('+breakindent') " move soft-wrapped lines to match the indent level.
    set breakindent
    set breakindentopt=shift:2
    let &showbreak='↪ '
endif

" searching ------------------------------------------------------------

set hlsearch            " highlight all search results
set incsearch           " increment search
set ignorecase          " case-insensitive search
set smartcase           " uppercase causes case-sensitive search
set wrapscan            " searches wrap back to the top of file
runtime macros/matchit.vim  " extend the % key

" complete -------------------------------------------------------------

set complete=.,b,u,]
set completeopt=menu,preview
set omnifunc=syntaxcomplete#Complete

" Vundle stuff ---------------------------------------------------------

call plug#begin('~/dots/vim/bundle')

Plug 'tpope/vim-sensible'

" editing-related plugins
Plug 'surround.vim'
Plug 'repeat.vim'
Plug 'tpope/vim-sleuth'     " autodetect tab format
Plug 'tpope/vim-unimpaired'
Plug 'ervandew/supertab'    " auto-completion in inser mode
Plug 'scrooloose/nerdcommenter'     " comment/uncomment things easy
Plug 'scrooloose/syntastic'
Plug 'kopischke/vim-stay'   " save folds
Plug 'kopischke/vim-fetch'  " parse '...:{num}' from files, jump to the line
Plug 'moll/vim-bbye'

Plug 'godlygeek/tabular' " align things easily
Plug 'junegunn/goyo.vim'    " distraction-free writing
Plug 'reedes/vim-pencil'    " make editing freetext easier
Plug 'tpope/vim-endwise' " add `end` do function blocks

Plug 'Gundo', {'on': 'GundoToggle'}
Plug 'ack.vim', {'on': 'Ack'}

" unite
Plug 'Shougo/vimproc.vim', { 'do' : 'make -f make_unix.mak' }
Plug 'Shougo/unite.vim'
Plug 'Shougo/unite-outline'
Plug 'Shougo/neomru.vim'
Plug 'Shougo/vimfiler.vim'
Plug 'romgrk/vimfiler-prompt'

" pretty plugins
Plug 'mhinz/vim-startify'
Plug 'xolox/vim-misc' " need this for colorscheme-switcher
Plug 'xolox/vim-colorscheme-switcher'
Plug 'flazz/vim-colorschemes'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" git plugins
Plug 'tpope/vim-fugitive'       " tight git integration
Plug 'airblade/vim-gitgutter'   " show git changes in the gutter
Plug 'wting/gitsessions.vim'    " handle vim sessions based on git
Plug 'tpope/vim-rhubarb'    " auto-complete Github in fugitive
Plug 'jaxbot/github-issues.vim' " Github issue lookup in Vim

Plug 'WebAPI.vim' " need this for gist.
Plug 'Gist.vim', {'on': 'Gist'}

" new syntaxes
Plug 'sheerun/vim-polyglot' " A tonne of new syntaxes.
Plug 'trapd00r/irc.vim' " syntax file for irc logs
Plug 'PotatoesMaster/i3-vim-syntax'
Plug 'freitass/todo.txt-vim'
Plug 'pearofducks/ansible-vim'
Plug 'TeX-9', {'for': ['tex', 'latex']}
Plug 'nelstrom/vim-markdown-folding', {'for': 'markdown'}
Plug 'skammer/vim-css-color', {'for': ['css', 'less']}
Plug 'mattn/emmet-vim', {'for': ['html', 'handlebars', 'css', 'less', 'sass', 'scss']} " emmet for vim: http://emmet.io/
Plug 'sealemar/vtl', {'for': 'velocity'} " velocity syntax for vim
Plug 'dln/avro-vim', {'for': 'avro-idl'}
Plug 'edkolev/erlang-motions.vim', {'for': 'erlang'}

call plug#end()

" colorscheme settings -------------------------------------------------------

let g:base16_shell_path=$COLORSCHEME_DIR."/shell/"
let base16colorspace=256
let g:zenesque_colors=2
let g:solarized_italic=0 " disable italics for solarized. They look ugly.
colorscheme github

if has('win32') || has('win64')
  colorscheme hornet
else
  let g:base16_shell_path='~/dots/colors/base16/shell/'
  colorscheme meatcar
  if $COLORSCHEME_LIGHT == 'dark'
    set background=dark
  else
    set background=light
  endif
endif
" Startify settings ----------------------------------------------------------

let g:startify_session_dir = '~/dots/vim/tmp/session'
let g:startify_skiplist = [
                \ 'COMMIT_EDITMSG',
                \ 'bundle/.*/doc',
                \ '/data/repo/neovim/runtime/doc',
                \ '/usr/share/vim/share/vim/vim74/doc',
                \ ]
let g:startify_custom_footer =
          \ ['', "   Vim is charityware. Please read ':help uganda'.", '']

let g:startify_custom_header =
      \ map(split(system('fortune work | cowsay -f www'), '\n'), '"   ". v:val') + ['']

let g:startify_change_to_dir = 1

" Airline settings -----------------------------------------------------------

let g:airline_theme='zenburn'
let g:airline_inactive_collapse=0
let g:airline_powerline_fonts=1
let g:airline#extensions#syntastic = 1
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline#extensions#tabline#buffer_min_count = 1
let g:airline#extensions#tabline#tab_min_count = 1
let g:airline#extensions#tabline#close_symbol = '×'

" Syntastic settings ---------------------------------------------------------

let g:syntastic_check_on_open=1
let g:syntastic_auto_loc_list=1
let g:syntastic_loc_list_height=3
let g:syntastic_javascript_checkers = ['eslint']
let g:syntastic_javascript_eslint_exec = 'eslint_d'

" Pencil settings ------------------------------------------------------------

if has('autocmd')
    augroup pencil
      autocmd!
      autocmd FileType markdown,mkd call pencil#init()
      autocmd FileType text         call pencil#init()
    augroup END
endif

" latex stuff. ---------------------------------------------------------

let g:tex_nine_config = {
    \'compiler': 'pdflatex',
    \'viewer': {'app':'zathura', 'target':'pdf'}
\}

" gist settings --------------------------------------------------------

let g:gist_clip_command = 'xclip -selection clipboard'
let g:gist_detect_filetype = 1
let g:gist_open_browser_after_post = 1
let g:gist_browser_command = 'google-chrome %URL% &'

" gissues settings ---------------------------------------------------

let g:github_access_token = '81acbbedd0b3845ab2db8d6044df60c140239e6d'
let g:gissues_async_omni = 0
let g:github_upstream_issues = 1

" gitgutter settings --------------------------------------------------------

" gitgutter is a bit slow. Let's speed it up
let g:gitgutter_realtime = 0
let g:gitgutter_eager = 0

" Unite ------------------------------------------------------------

" set fuzzy matcher
call unite#custom_source('file,file/new,buffer,file_rec,file_rec/async,file_mru,directory,directory_mru',
      \'matchers', [
          \'matcher_fuzzy'
      \])
call unite#custom_source('file,file/new,buffer,file_rec,file_rec/async,file_mru,directory,directory_mru',
      \'sorters', [
          \'sorter_rank'
      \])

"call unite#custom_source('file,file/new,buffer,file_rec,file_rec/async,file_mru,directory,directory_mru',
      "\'converters', [
          "\'converter_relative_abbr'
      "\])

call unite#custom_source('file,file/new,buffer,file_rec,file_rec/async,file_mru,directory,directory_mru',
      \'ignore_pattern', join([
          \'node_modules',
          \'\.git',
      \], '\|'))

let g:unite_data_directory = expand('~/dots/vim/tmp/unite/')
let g:unite_source_process_enable_confirm = 1
let g:unite_source_history_yank_enable = 1
let g:unite_enable_split_vertically = 0
let g:unite_winheight = 20
let g:unite_source_rec_max_cache_files = 500
let g:unite_source_directory_mru_limit = 200
let g:unite_source_file_mru_limit = 500
let g:unite_source_file_mru_filename_format = ':~:.'
let g:unite_cursor_line_highlight = 'CursorLine'

if has('win32') || has('win64')
    let g:unite_source_grep_command = 'ag'
    let g:unite_source_grep_default_opts =
          \ '-i --vimgrep --hidden --ignore ' .
          \ '''.hg'' --ignore ''.svn'' --ignore ''.git'' --ignore ''.bzr'''
    let g:unite_source_grep_recursive_opt = ''
    let g:unite_source_rec_async_command = [
          \'C:/ProgramData/chocolatey/bin/ag',
          \'--follow', '--nocolor', '--nogroup', '--hidden', '-g', '']
else
    let g:unite_source_grep_command = 'ack'
    let g:unite_source_grep_default_opts = '--column --no-color --nogroup --with-filename'
    let g:unite_source_grep_recursive_opt = ''
endif

function! s:unite_settings()
  map <buffer> <leader> <Esc><leader>
  nmap <buffer> q <Plug>(unite_exit)
  nmap <buffer> <esc> <Plug>(unite_exit)
  imap <buffer> <esc> <Plug>(unite_exit)
endfunction

if has('autocmd')
    augroup UniteAutoCmd
        autocmd!
        autocmd FileType unite call s:unite_settings()
    augroup END
endif

" ack/grep
nno <leader>a :<C-u>Unite grep -default-action=above<CR>
nno <leader>A :<C-u>execute 'Unite grep:.::' . expand("<cword>") . ' -default-action=above -auto-preview'<CR>
" ctrl-p
nno <leader>t :<C-u>Unite file_rec/async -start-insert -buffer-name=files -no-split<CR>
nno <C-p>     :<C-u>Unite file_rec/async -start-insert -buffer-name=files -no-split<CR>
" cd
nno <leader>cd :<C-u>Unite directory
            \ -start-insert
            \ -buffer-name=cd
            \ -default-action=cd
            \<CR>
" processes
nno <leader>o :<C-u>:Unite outline -buffer-name=outline -vertical<CR>
" search in file
nno // :<C-u>:Unite line -buffer-name=lines -start-insert -direction=botright -winheight=10<CR>
" yanks
nno <leader>y :<C-u>:Unite history/yank -buffer-name=yanks<CR>
" buffers
nno <leader>b :<C-u>Unite buffer -buffer-name=buffers -start-insert -no-split -toggle<CR>
" processes
nno <leader>ps :<C-u>:Unite process -buffer-name=processes -start-insert<CR>
" vimviki
map <leader>w :<C-u>Unite file_rec/async file/new -buffer-name=notes -start-insert
      \ -path=/home/meatcar/Sync/notes/ -toggle -profile-name=files <CR>

" VimFiler ------------------------------------------------------------
let g:vimfiler_data_directory = expand('~/dots/vim/tmp/vimfiler/')
let g:vimfiler_safe_mode_by_default = 0
" disable netrw.vim
let g:loaded_netrwPlugin = 1
let g:vimfiler_as_default_expolorer = 1
nno ` :<C-u>:VimFilerBufferDir -buffer-name=explorer -status -force-quit<CR>

function! s:vimfiler_settings()
  nmap <buffer> ` <Plug>(vimfiler_exit)
  nmap <buffer> <leader>q <Plug>(vimfiler_exit)
  nmap <buffer> i :VimFilerPrompt<CR>
  nmap <buffer> H :bp<CR>
  nmap <buffer> L :bn<CR>
endfunction

autocmd UniteAutoCmd Filetype vimfiler call s:vimfiler_settings()

" gvim settings --------------------------------------------------------

if has ("gui_running")
    set lsp=0             "set linespacing"

    " Set the font -----------------------------------
    if has("unix")
        let s:uname = system("uname")
        if s:uname == "Darwin\n" " osx
            set guifont=Fantasque\ Sans\ Mono:h11,Monaco:h11
        else " linux
            set guifont=Fantasque\ Sans\ Mono\ 11,Monospace\ 11
        endif
    elseif has("win32") || has("win64")
        set guifont=Fantasque\ Sans\ Mono:h11,Consolas:h11
    endif

    set guioptions-=T      "hide the toolbar
    set guioptions-=m      "hide the manubar
endif

" autocmd rules --------------------------------------------------------

if has("autocmd")
    " define a group `vimrc` and initialize
    augroup vimrc
        autocmd!

        "remove trailing whitespace upon save
        autocmd FileType javascript,python,tex,java autocmd BufWritePre * :%s/\s\+$//e

        " Set filetypes based on extensions
        autocmd BufNewFile,BufRead *.less set filetype=less
        autocmd BufNewFile,BufRead *.glsl set filetype=glsl
        autocmd BufNewFile,BufRead *.erl,*.es,*.hrl,*.yaws,*.xrl set filetype=erlang
        autocmd BufNewFile,BufRead *.rs set filetype=rust
        autocmd BufNewFile,BufRead *.avdl set filetype=avro-idl
        autocmd BufNewFile,BufRead
                    \ *.service,*.target,*.socket,*.device,*.mount,*.snapshot,*.timer,*.swap,*.path,*.slice,*.scope,*.special
                    \ set filetype=systemd

        autocmd BufNewFile,BufRead *.md set filetype=markdown
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

        autocmd BufRead,BufNewFile PKGBUILD set ft=sh
        autocmd FileType fish compiler fish
    augroup END
endif


" hotkeys --------------------------------------------------------------

" typo corrections
nmap q: :q<cr>
nmap <silent> <leader>q :Bdelete<CR>
command! BW :Bdelete     " easier buffer closing
command! SO :so ~/.vimrc " source

nmap <C-j> <C-W>j
nmap <C-k> <C-W>k
nmap <C-h> <C-W>h
nmap <C-l> <C-W>l

nmap <silent> <leader>g :GundoToggle<CR>

nmap <silent> H :bp<CR>
nmap <silent> L :bn<CR>

