local map = vim.api.nvim_set_keymap
local bmap = vim.api.nvim_buf_set_keymap

map('n', 'q:', [[ <Cmd>q<CR> ]], {})
map('n', 'H', [[ [b ]], { silent = true })
map('n', 'L', [[ ]b ]], { silent = true })

map('v', '<', [[ <gv ]], { noremap = true })
map('v', '>', [[ >gv ]], { noremap = true })

-- improve netrw a-la tpope/vim-vinegar
function _G.me.fn.keymap_netrw()
  bmap('n', 'q', [[ <C-^> ]], {})
  bmap('n', 'h', [[ - ]], {})
  bmap('n', 'l', [[ <CR> ]], {})
  bmap('n', 't', [[ i ]], {})
  vim.bo.bufhidden = 'wipe'
end
vim.cmd [[ autocmd vimrc FileType netrw lua me.fn.keymap_netrw() ]]

-- get back to normal mode quickly
map('t', '<Esc><Esc>', [[ <C-\><C-n> ]], { noremap = true })
