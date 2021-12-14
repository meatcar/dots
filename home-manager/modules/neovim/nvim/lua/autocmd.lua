vim.cmd [[ augroup vimrc ]]
vim.cmd [[   autocmd! ]]
vim.cmd [[ augroup END ]]

-- cursorline in focused windows
vim.cmd [[ autocmd vimrc WinEnter,BufEnter * setlocal cursorline ]]
vim.cmd [[ autocmd vimrc WinLeave,BufLeave * setlocal nocursorline ]]

-- remember folds
vim.cmd [[ autocmd vimrc BufWinLeave ?* mkview ]]
vim.cmd [[ autocmd vimrc BufWinEnter ?* silent! loadview ]]

-- Fix old themes colouring SignColumn an ugly grey:
vim.cmd [[ autocmd vimrc ColorScheme * hi clear SignColumn \| hi! link SignColumn LineNr ]]

-- spelling
vim.cmd [[ autocmd vimrc FileType md,markdown,mail setlocal spell ]]
