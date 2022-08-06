vim.keymap.set('n', 'q:', [[ <Cmd>q<CR> ]], {})
vim.keymap.set('n', 'H', [[ [b ]], { silent = true })
vim.keymap.set('n', 'L', [[ ]b ]], { silent = true })

vim.keymap.set('v', '<', [[ <gv ]])
vim.keymap.set('v', '>', [[ >gv ]])

-- improve netrw a-la tpope/vim-vinegar
function _G.me.fn.keymap_netrw()
  vim.keymap.set('n', 'q', [[ <C-^> ]], { buffer = true })
  vim.keymap.set('n', 'h', [[ - ]], { buffer = true })
  vim.keymap.set('n', 'l', [[ <CR> ]], { buffer = true })
  vim.keymap.set('n', 't', [[ i ]], { buffer = true })
  vim.bo.bufhidden = 'wipe'
end
vim.cmd [[ autocmd vimrc FileType netrw lua me.fn.keymap_netrw() ]]

-- get back to normal mode quickly
vim.keymap.set('t', '<Esc><Esc>', [[ <C-\><C-n> ]], { noremap = true })

-- lsp maps
function _G.me.fn.keymap_lsp_on_attach(_, bufnr)
  vim.keymap.set('n', 'gr', '<Cmd>Lspsaga rename<CR>', { silent = true, buffer = bufnr })
  vim.keymap.set('n', 'gx', '<Cmd>Lspsaga code_action<CR>', { silent = true, buffer = bufnr })
  vim.keymap.set('x', 'gx', ':<C-u>Lspsaga range_code_action<CR>', { silent = true, buffer = bufnr })
  vim.keymap.set('n', 'K', '<Cmd>Lspsaga hover_doc<CR>', { silent = true, buffer = bufnr })
  vim.keymap.set('n', 'go', '<Cmd>Lspsaga show_line_diagnostics<CR>', { silent = true, buffer = bufnr })
  vim.keymap.set('n', 'gj', '<Cmd>Lspsaga diagnostic_jump_next<CR>', { silent = true, buffer = bufnr })
  vim.keymap.set('n', 'gk', '<Cmd>Lspsaga diagnostic_jump_prev<CR>', { silent = true, buffer = bufnr })
  vim.keymap.set('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', { silent = true, buffer = bufnr })
  vim.keymap.set('n', '<C-u>', "<Cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1)<CR>", { buffer = bufnr })
  vim.keymap.set('n', '<C-d>', "<Cmd>lua require('lspsaga.action').smart_scroll_with_saga(1)<CR>", { buffer = bufnr })
end
