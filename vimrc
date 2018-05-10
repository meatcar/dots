"----------------------------------------------------------------------
" file:     ~/.vimrc
" author:   Denys Pavlov
" modified: January 15, 2011
" vim:nu:ai:si:et:ts=4:sw=4:ft=vim:
"----------------------------------------------------------------------

"----------------------------------------------------------------------
" general

"set nocompatible        " disregard vi compatibility:
set t_Co=256            " enable 256-color support
set title

if &shell =~? 'fish$'
    set shell=sh      " fish is messed
elseif has('unix')
    set shell=/bin/sh " zsh colors are messed
endif

set runtimepath+=~/dots/vim,"$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,~/dots/vim/after
set directory=~/dots/vim/tmp/swap         " keep swap files in one place
set backupdir=~/dots/vim/tmp/backup " keep backups in one place
set undodir=~/dots/vim/tmp/undo     " keep undos in one place
set viewdir=~/dots/vim/tmp/view     " keep views in one place
let &viminfo="'100,n".expand('~/dots/vim/tmp/viminfo')
set encoding=utf-8        " UTF-8 encoding for all new files
scriptencoding 'utf-8'
set termencoding=utf-8    " force terminal encoding
set mouse=a               " allow mouse input in all modes
set ttymouse=xterm2       " enable scrolling within screen sessions (MUST HAVE)
set backspace=2           " full backspacing capabilities (indent,eol,start)
set history=100           " 100 lines of command line history
set timeoutlen=1000 
set ttimeoutlen=0
set nonumber              " show line numbers
set norelativenumber      " show line numbers
set numberwidth=1         " minimum num of cols to reserve for line numbers
set nobackup              " disable backup files (filename~)
set showmatch             " show matching brackets (),{},[]
set whichwrap=h,l,<,>,[,] " whichwrap -- left/right keys can traverse up/down
set wrap                  " wrap long lines to fit terminal width
set ttyfast               " tell vim we're using a fast terminal for redraws
set lazyredraw            " don't redraw while running commands
set autoread              " reload file if vim detects it changed elsewhere
set wildmenu              " enhanced tab-completion shows all matching cmds
set splitbelow            " place the new split below the current file
set autowrite             " write file if modified on each :next, :make, etc.
set writebackup           " make a backup before writing a file until successful
set previewheight=9       " default height for a preview window (def:12)
syntax on                 " enable syntax highlighting
filetype plugin indent on " enable filetype-sensitive plugins and indenting
set wildmenu
set wildmode=longest,list:longest
set hidden          " un-saved buffers in the background
set colorcolumn=80
set textwidth=0
set linebreak
let &wrapmargin=0
set laststatus=2    " show the status bar even when editing one file.
set matchpairs+=<:>

let g:mapleader = ' ' "leader is space

set diffopt-=iwhite " ignore whitespace when diffing
let &listchars='tab:⇥ ,eol:$,trail:·,extends:>,precedes:<' " set list
let &fillchars='vert:│,fold: '

if v:version > 703 || v:version == 703 && has('patch541')
  set formatoptions+=j
endif

"----------------------------------------------------------------------
" folds

set foldmethod=syntax
set viewoptions=cursor,folds,slash,unix " save folds, cursor position

function! NeatFoldText()
     "get first non-blank line
     let l:fs = v:foldstart
     while getline(l:fs) =~# '^\s*$' | let l:fs = nextnonblank(l:fs + 1)
     endwhile
     if l:fs > v:foldend
         let l:line = getline(v:foldstart)
     else
         let l:line = substitute(getline(l:fs), '\t', repeat(' ', &tabstop), 'g')
     endif

     let l:w = winwidth(0) - &foldcolumn - (&number ? 8 : 0)
     let l:foldSize = 1 + v:foldend - v:foldstart
     let l:foldSizeStr = ' ' . l:foldSize . ' lines '
     let l:foldLevelStr = repeat(' ╢', v:foldlevel).' '.v:foldlevel
     let l:lineCount = line('$')
     let l:foldPercentage = printf('[%.1f', (l:foldSize*1.0)/l:lineCount*100) . '%] '
     let l:expansionString = repeat('.', l:w - strwidth(l:foldSizeStr.l:line.l:foldLevelStr.l:foldPercentage))
     return l:line . l:expansionString . l:foldSizeStr . l:foldPercentage . l:foldLevelStr
endfunction
set foldtext=NeatFoldText()

"----------------------------------------------------------------------
" tabs and indenting

set expandtab             " insert spaces instead of tabs
set tabstop=4             " n space tab width
set shiftwidth=4          " allows the use of < and > for VISUAL indenting
set softtabstop=4         " counts n spaces when DELETE or BCKSPCE is used
set smarttab              " set <Tab>s according to shiftwidth
set autoindent            " auto indents next new line
set nocindent             " C style indenting off
set formatoptions=tcqr    " recommended defaults from O'Reilly
if exists('+breakindent') " move soft-wrapped lines to match the indent level.
    set breakindent
    set breakindentopt=shift:2
    let &showbreak='↳ '
endif

"----------------------------------------------------------------------
" searching

set hlsearch            " highlight all search results
set incsearch           " increment search
set ignorecase          " case-insensitive search
set smartcase           " uppercase causes case-sensitive search
set wrapscan            " searches wrap back to the top of file
runtime macros/matchit.vim  " extend the % key

"----------------------------------------------------------------------
" Plugins

call plug#begin('~/dots/vim/pack/bundle/start')

Plug 'tpope/vim-sensible'
Plug 'tpope/vim-eunuch'
Plug 'pbrisbin/vim-mkdir'


" editing-related plugins
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sleuth'         " autodetect tab format
Plug 'tpope/vim-unimpaired'
Plug 'scrooloose/nerdcommenter' " comment/uncomment things easy
Plug 'w0rp/ale'
Plug 'kopischke/vim-stay'       " save folds
Plug 'Konfekt/FastFold'         " speed up fold handling
Plug 'kopischke/vim-fetch'      " parse '...:{num}' from files, jump to the line
Plug 'moll/vim-bbye'            " :Bdelete, remove cur buf without killing window
Plug 'xtal8/traces.vim'         " highlight while editing commandline

Plug 'godlygeek/tabular' " align things easily
Plug 'junegunn/goyo.vim' " distraction-free writing
Plug 'reedes/vim-pencil' " make editing freetext easier
Plug 'tpope/vim-endwise' " add `end` do function blocks
Plug 'thinca/vim-fontzoom' " zoom fontsize

Plug 'Olical/vim-enmasse' " mass edit every line in a quickfix

Plug 'sjl/gundo.vim', {'on': 'GundoToggle'} " undo tree
Plug 'editorconfig/editorconfig-vim'        " support editorconfig
Plug 'airblade/vim-rooter'                  " auto-cd to vcs root

" netrw sanity
Plug 'tpope/vim-vinegar'

" completion
Plug 'maralla/completor.vim', {'do': 'make js'}

" snippets
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

" pretty plugins
Plug 'mhinz/vim-startify'             " startup screen
Plug 'flazz/vim-colorschemes'         " all the colorschemes
Plug 'dracula/vim'                    " the best colorscheme
Plug 'NLKNguyen/papercolor-theme'     " more themes
Plug 'rakr/vim-two-firewatch'         " .
Plug 'danilo-augusto/vim-afterglow'   " .
Plug 'dylanaraps/wal.vim'             " .
Plug 'vim-airline/vim-airline'        " statusline
Plug 'vim-airline/vim-airline-themes' " statusline themes
Plug 'ryanoasis/vim-devicons'         " filetype icons

Plug 'inkarkat/vim-ingo-library' " dep for below.
Plug 'inkarkat/vim-SyntaxRange'  " set portion of buffer as another filetype

" git plugins
Plug 'jreybert/vimagit'         " tight git integration, like emacs magit
Plug 'tpope/vim-fugitive'       " tight git integration
Plug 'mhinz/vim-signify'        " show git changes in the gutter
Plug 'wting/gitsessions.vim'    " handle vim sessions based on git
Plug 'tpope/vim-rhubarb'        " auto-complete Github issues in fugitive
Plug 'jaxbot/github-issues.vim' " Github issue lookup in Vim
Plug 'shuber/vim-promiscuous'   " links vim sessions with git branch

Plug 'mattn/webapi-vim' " need this for gist.
Plug 'mattn/gist-vim', {'on': 'Gist'} " post to gist.github.com

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': 'yes \| ./install' }
Plug 'junegunn/fzf.vim'         " for vim-promiscuous

" syntaxes
Plug 'sheerun/vim-polyglot'              " A tonne of new syntaxes.
Plug 'PotatoesMaster/i3-vim-syntax'
Plug 'freitass/todo.txt-vim'
Plug 'zirrostig/vim-shbed'
Plug 'vim-scripts/TeX-9', {'for': ['tex', 'latex']}
Plug 'tomtom/foldtext_vim', {'for': 'markdown'}
Plug 'skammer/vim-css-color', {'for': ['css', 'less', 'scss', 'sass']}
Plug 'KabbAmine/vCoolor.vim', {'for': ['css', 'less', 'scss', 'sass']}
Plug 'mattn/emmet-vim', {
            \'for': ['html', 'handlebars', 'css', 'less', 'sass', 'scss']
            \}                           " emmet for vim: http://emmet.io/
Plug 'sealemar/vtl', {'for': 'velocity'} " velocity syntax for vim
Plug 'dln/avro-vim', {'for': 'avro-idl'}
Plug 'edkolev/erlang-motions.vim', {'for': 'erlang'}
Plug 'rhysd/open-pdf.vim', {'for': 'pdf'}
Plug 'neomutt/neomutt.vim', {'for': 'mail'}
"Plug 'ternjs/tern_for_vim', {'for': 'javascript', 'do': 'npm install'}
Plug 'saltstack/salt-vim', {'for': 'sls'}

call plug#end()

"-------------------------------------------------------
" colorscheme settings

let g:zenesque_colors=2
let g:solarized_italic=0 " disable italics for solarized. They look ugly.
let g:pencil_gutter_color = 1

if has('win32') || has('win64')
  colorscheme hornet
else
  if has('gui_running')
    set background=dark
    colorscheme dracula
  else
    colorscheme wal
  endif
endif

"----------------------------------------------------------------------
" Startify settings

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
      \ map(split(system('fortune work | cowsay -f www'), '\n'), "'  '. v:val")
      \ + ['']

let g:startify_change_to_dir = 1

"----------------------------------------------------------------------
" Airline settings

if has('gui_running')
    let g:airline_theme='zenburn'
else
    let g:airline_theme='wal'
endif
let g:airline_inactive_collapse=1
let g:airline_powerline_fonts=1
let g:airline_detect_spell=1
let g:airline_mode_map = {}

let g:airline_extensions = ['branch', 'ale', 'vimagit']
let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#tabline#enabled = 0
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline#extensions#tabline#buffers_label = 'buf'
let g:airline#extensions#tabline#tabs_label = 'tab'
let g:airline#extensions#tabline#buffer_min_count = 1
let g:airline#extensions#tabline#tab_min_count = 1
let g:airline#extensions#tabline#close_symbol = '×'

" -------------------------
"  ALE settings

"let g:ale_javascript_eslint_exectuable = 'eslint_d'
"let g:ale_javascript_eslint_use_global = 1
let g:ale_linter_aliases = {
            \'vimwiki': 'markdown',
            \}
let g:ale_lint_on_text_changed = 'never'
let g:ale_fixers = {
            \   'javascript': ['eslint'],
            \   'css':        ['stylelint'],
            \   'scss':       ['stylelint'],
            \   'python':     ['autopep8'],
            \}
let g:ale_fix_on_save = 1
let g:ale_open_list = 1
let g:ale_list_window_size = 3

"----------------------------------------------------------------------
" signify
let g:signify_vcs_list        = [ 'git' ]
let g:signify_sign_change     = '~'
let g:signify_sign_show_count = 1

highlight SignifySignAdd    ctermbg=none ctermfg=2 guibg=bg guifg=green
highlight SignifySignDelete ctermbg=none ctermfg=1 guibg=bg guifg=#ff3333
highlight SignifySignChange ctermbg=none ctermfg=3 guibg=bg guifg=yellow
highlight link SignifySignChangeDelete    SignifySignChange
highlight link SignifySignDeleteFirstLine SignifySignDelete

"----------------------------------------------------------------------
" completion

set noshowmode shortmess+=c
set noinfercase
set completeopt-=longest
set completeopt+=menuone
set completeopt-=menu
if &completeopt !~# 'noinsert\|noselect'
  set completeopt+=noselect
endif
set completeopt-=preview

"----------------------------------------------------------------------
" Vim Wiki

let g:vimwiki_list = [{
            \ 'path': '~/Sync/notes/',
            \ 'diary_rel_path': 'journal/',
            \ 'diary_index': 'journal',
            \ 'diary_header': 'Journal',
            \ 'syntax': 'markdown',
            \ 'ext': '.md',
            \ 'automatic_nested_syntaxes': 1,
            \ 'auto_toc': 1,
            \ 'auto_tags': 1
            \ }]

let g:vimwiki_ext2syntax = {'.md': 'markdown',
            \ 'todo.txt': 'todo',
            \ 'txt': 'markdown',
            \ '.mkd': 'markdown',
            \ '.wiki': 'media'}

let g:vimwiki_listsyms = '✗○◐●✓'
let g:vimwiki_use_mouse = 1


"----------------------------------------------------------------------
" Ul

"----------------------------------------------------------------------
" Pencil settings

if has('autocmd')
    augroup pencil
      autocmd!
      autocmd FileType txt call PencilOff
    augroup END
endif

"----------------------------------------------------------------------
" latex stuff.

let g:tex_nine_config = {
    \'compiler': 'pdflatex',
    \'viewer': {'app':'zathura', 'target':'pdf'}
\}

"----------------------------------------------------------------------
" gist settings

let g:gist_clip_command = 'xclip -selection clipboard'
let g:gist_detect_filetype = 1
let g:gist_open_browser_after_post = 1
let g:gist_browser_command = 'google-chrome %URL% &'

"----------------------------------------------------------------------
" gissues settings

let g:gissues_async_omni = 0
let g:github_upstream_issues = 1

"----------------------------------------------------------------------
" gitgutter settings

" gitgutter is a bit slow. Let's speed it up
let g:gitgutter_realtime = 0
let g:gitgutter_eager = 0

"------------------------------------------------------------------------------
" FastFold

nmap zuz <Plug>(FastFoldUpdate)
let g:fastfold_savehook = 1
let g:fastfold_fold_command_suffixes =  ['x','X','a','A','o','O','c','C']
let g:fastfold_fold_movement_commands = [']z', '[z', 'zj', 'zk']

"----------------------------------------------------------------------
" Promiscuous settings

let g:promiscuous_dir = $HOME . '/.vim/tmp/promiscuous'
nmap <leader>gb :Promiscuous<cr>
nmap <leader>gg :Promiscuous -<cr>

"----------------------------------------------------------------------
" FZF settings

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

command! -bang -nargs=* Rg
            \ call fzf#vim#grep(
            \   'rg --column --line-number --no-heading --color=always '
            \    . '--hidden --smart-case --fixed-strings '.shellescape(<q-args>), 1,
            \   <bang>0 ? fzf#vim#with_preview('up:60%')
            \           : fzf#vim#with_preview('right:50%:hidden', '?'),
            \   <bang>0)

set grepprg=rg\ --vimgrep
set grepformat^=%f:%l:%c:%m

" buffers
nno <leader>b :<C-u>Buffers<CR>
" buffers
nno <leader>r :<C-u>History<CR>
" ack/grep
nno <leader>f :<C-u>Rg<space>
" grep word under cursor
nno <leader>F :<C-u>execute 'Rg ' . expand("<cword>")<CR>
" ctrl-p
nno <leader>t :<C-u>Files<CR>
nno <C-p>     :<C-u>Files<CR>
nno <leader>pf :<C-u>Files<CR>

nno <leader>gf :<C-u>GFiles<CR>
nno <leader>gF :<C-u>GFiles?<CR>

nno <leader>: :<C-u>Commands<CR>
" search in file
nno // :<C-u>BLines<CR>
" vimviki
map <leader>w :<C-u>FZF /home/meatcar/Sync/notes/ <CR>
" filetypes
nno <leader>ft :<C-u>Filetypes<CR>

nmap <silent> <leader>s :Snippets<CR>

imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-j> <plug>(fzf-complete-file-ag)
imap <c-x><c-l> <plug>(fzf-complete-line)

nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)

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

"----------------------------------------------------------------------
" Notes settings

let g:notes_directories = ['~/Sync/notes']
let g:notes_suffix = '.md'

"----------------------------------------------------------------------
" EditorConfig

let g:EditorConfig_exclude_patterns = ['fugitive://.*']

"----------------------------------------------------------------------
" PDF

let g:pdf_convert_on_edit = 1
let g:pdf_convert_on_read = 1

"----------------------------------------------------------------------
" netrw

let g:netrw_altfile = 1
let g:netrw_keepdir = 0
let g:netrw_liststyle = 1
let g:netrw_hide = 1
let g:netrw_list_hide= netrw_gitignore#Hide().'\(^\|\s\s\)\zs\.\S\+'
let g:netrw_special_syntax = 'true'
let g:netrw_sort_options = 'i'
let g:netrw_localrmdir='rm -r'

"----------------------------------------------------------------------
" auto-cd based on file (from http://inlehmansterms.net/2014/09/04/sane-vim-working-directories/)

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

"----------------------------------------------------------------------
" gvim settings

if has ('gui_running')

    " Set the font -----------------------------------
    if has('unix')
        let s:uname = system('uname')
        if s:uname ==? 'Darwin\n' " osx
            set guifont=Fantasque\ Sans\ Mono:h10,Monaco:h10
        else " linux
            set linespace=0             "set linespacing
            set guifont=Iosevka\ Nerd\ Font\ 9,Monospace\ 9,FontAwesome\ 9,EmojiOne\ Color\ 9
        endif
    elseif has('win32') || has('win64')
        set guifont=Fantasque\ Sans\ Mono:h10,Consolas:h10
    endif

    set guioptions-=T      "hide the toolbar
    set guioptions-=m      "hide the manubar
endif

"----------------------------------------------------------------------
" autocmd rules

let g:vue_disable_pre_processors=1

if has('autocmd')
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
        autocmd BufNewFile,BufRead *.jsx set filetype=javascript.jsx
        autocmd BufNewFile,BufRead *.vue set filetype=vue.html.javascript.css

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

        autocmd BufRead,BufNewFile mail set tw=0
        autocmd BufRead,BufNewFile mail set wrapmargin=3

        autocmd FileType md,markdown,mail setlocal spell

        "auto-close completion preview window
        autocmd CompleteDone * if pumvisible() == 0 | pclose | endif

        " auto-cd based on file (from http://inlehmansterms.net/2014/09/04/sane-vim-working-directories/)
        " follow symlink and set working directory
        autocmd BufRead *
                    \ call FollowSymlink() |
                    \ call SetProjectRoot()

        " short circuit for non-netrw files
        autocmd CursorMoved silent *
                    \ if &filetype == 'netrw' |
                    \   call FollowSymlink() |
                    \   call SetProjectRoot() |
                    \ endif


        autocmd User Startified setlocal buftype=nofile
    augroup END
endif

"----------------------------------------------------------------------
" Hotkeys

" typo corrections
nmap q: :q<cr>
nmap <silent> <leader>q :Bdelete<CR>
command! BW :Bdelete     " easier buffer closing
command! SO :so ~/.vimrc " source
" vertical split help
command! -nargs=* -complete=help Vhelp :vert bo help <args>

nmap <C-j> <C-W>j
nmap <C-k> <C-W>k
nmap <C-h> <C-W>h
nmap <C-l> <C-W>l

nmap <silent> <leader>u :GundoToggle<CR>

nmap <silent> <leader>gs :Magit<CR>
nmap <silent> <leader>C :Color<CR>

nmap <silent> H :bp<CR>
nmap <silent> L :bn<CR>

vnoremap < <gv
vnoremap > >gv

let g:fontzoom_no_default_key_mappings = 1
nmap <silent> <C-ScrollWheelUp>	<Plug>(fontzoom-larger)
nmap <silent> <leader>+	<Plug>(fontzoom-larger)
nmap <silent> <leader>=	<Plug>(fontzoom-larger)
nmap <silent> <C-ScrollWheelDown>	<Plug>(fontzoom-smaller)
nmap <silent> <leader>-	<Plug>(fontzoom-smaller)
nmap <silent> <leader>0 :Fontzoom!<cr>

nmap ` <Plug>VinegarUp

augroup vimrc
    autocmd FileType netrw call s:filer_settings()
augroup END

function! s:filer_settings()
    nmap <buffer> ` <C-^>
    nmap <buffer> q <C-^>
    nmap <buffer> h -
    nmap <buffer> l <CR>
    nmap <buffer> t i
    setl bufhidden=wipe
endfunction

" tab completion
"inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
"inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
"inoremap <expr> <cr> pumvisible() ? "\<C-y>\<cr>" : "\<cr>"
