local function map(mode, lhs, rhs, opts)
  local options = {}
  if opts then
    options = vim.tbl_extend('force', options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

map('n', 'q:', [[ <Cmd>q<CR> ]], {})
map('n', 'H', [[ [b ]], { silent = true })
map('n', 'L', [[ ]b ]], { silent = true })

map('v', '<', [[ <gv ]], { noremap = true })
map('v', '>', [[ >gv ]], { noremap = true })

-- improve netrw a-la tpope/vim-vinegar
_G.me.file_mappings = function()
  vim.api.nvim_buf_set_keymap('n', 'q', [[ <C-^> ]], {})
  vim.api.nvim_buf_set_keymap('n', 'h', [[ - ]], {})
  vim.api.nvim_buf_set_keymap('n', 'l', [[ <CR> ]], {})
  vim.api.nvim_buf_set_keymap('n', 't', [[ i ]], {})
  vim.bo.bufhidden = 'wipe'
end
vim.cmd [[ autocmd vimrc FileType netrw lua me.file_mappings() ]]

-- terminal
-- get back to normal mode quickly
map('t', '<Esc><Esc>', [[ <C-\><C-n> ]], {noremap = true})

_G.me.term = function(bang, rest)
  local cmd = 'terminal'
  if bang then
    cmd = cmd .. '!'
  end
  local args = ''
  if rest ~= '' then
    args = '-c "' .. rest .. '"'
  end
  vim.fn.execute(cmd .. ' ' .. vim.env.SHELL .. ' ' .. args)
end
vim.cmd [[ command! -nargs=* -bang -complete=shellcmd Term :lua me.term(<q-bang> ~= '!', <q-args>) ]]

vim.cmd [[ autocmd vimrc TermOpen term://* startinsert ]]
vim.cmd [[ autocmd vimrc TermClose term://* bdelete! ]]
