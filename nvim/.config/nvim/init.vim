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
set packpath=$XDG_CONFIG_HOME/nvim,$VIMRUNTIME,$XDG_CONFIG_HOME/nvim/after

source $XDG_CONFIG_HOME/nvim/config.vim
