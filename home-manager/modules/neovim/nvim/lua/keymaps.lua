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

-- lsp maps
function _G.me.fn.keymap_lsp_on_attach(_, bufnr)
  bmap(bufnr, 'n', 'gr', '<Cmd>Lspsaga rename<CR>', { silent = true, noremap = true })
  bmap(bufnr, 'n', 'gx', '<Cmd>Lspsaga code_action<CR>', { silent = true, noremap = true })
  bmap(bufnr, 'x', 'gx', ':<C-u>Lspsaga range_code_action<CR>', { silent = true, noremap = true })
  bmap(bufnr, 'n', 'K', '<Cmd>Lspsaga hover_doc<CR>', { silent = true, noremap = true })
  bmap(bufnr, 'n', 'go', '<Cmd>Lspsaga show_line_diagnostics<CR>', { silent = true, noremap = true })
  bmap(bufnr, 'n', 'gj', '<Cmd>Lspsaga diagnostic_jump_next<CR>', { silent = true, noremap = true })
  bmap(bufnr, 'n', 'gk', '<Cmd>Lspsaga diagnostic_jump_prev<CR>', { silent = true, noremap = true })
  bmap(bufnr, 'n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', { silent = true, noremap = true })
  bmap(bufnr, 'n', '<C-u>', "<Cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1)<CR>", {})
  bmap(bufnr, 'n', '<C-d>', "<Cmd>lua require('lspsaga.action').smart_scroll_with_saga(1)<CR>", {})
end
