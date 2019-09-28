" For a paranoia.
" Normally `:set nocp` is not needed, because it is done automatically
" when .vimrc is found.
if &compatible
    " `:set nocp` has many side effects. Therefore this should be done
    " only when 'compatible' is set.
    set nocompatible
endif

set undodir=$XDG_CACHE_HOME/nvim/undo
set directory=$XDG_CACHE_HOME/nvim/swap
set backupdir=$XDG_CACHE_HOME/nvim/backup
set viewdir=$XDG_CACHE_HOME/nvim/view
set runtimepath+=$XDG_CONFIG_HOME/nvim,$VIMRUNTIME,$XDG_CONFIG_HOME/nvim/after
set packpath=$XDG_DATA_HOME/nvim,$VIMRUNTIME

if empty(glob($XDG_CACHE_HOME."/nvim/"))
  call mkdir($XDG_CACHE_HOME."/nvim/undo", "p")
  call mkdir($XDG_CACHE_HOME."/nvim/swap", "p")
  call mkdir($XDG_CACHE_HOME."/nvim/backup", "p")
  call mkdir($XDG_CACHE_HOME."/nvim/view", "p")
endif

if empty(glob($XDG_DATA_HOME."/nvim/"))
  silent !mkdir -p $XDG_DATA_HOME/nvim
endif

runtime config.vim
