" For a paranoia.
" Normally `:set nocp` is not needed, because it is done automatically
" when .vimrc is found.
if &compatible
    " `:set nocp` has many side effects. Therefore this should be done
    " only when 'compatible' is set.
    set nocompatible
endif

let s:data_dir = stdpath('data')
let s:cache_dir = stdpath('cache')
let s:config_dir = stdpath('config')

exe 'set undodir=' . s:cache_dir . '/undo'
exe 'set directory=' . s:cache_dir . '/directory'
exe 'set backupdir=' . s:cache_dir . '/backup'
exe 'set viewdir=' . s:cache_dir . '/view'

for dir in [&undodir, &directory, &backupdir, &viewdir]
  if !isdirectory(dir)
    call mkdir(dir, 'p')
  endif
endfor

if exists('g:vscode')
  " VSCode extension
  echomsg 'vscode' g:vscode
else
  " ordinary neovim
  runtime config.vim
endif
