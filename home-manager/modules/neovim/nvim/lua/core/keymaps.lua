local M = {}

M.main = function()
  vim.keymap.set('n', 'q:', [[<Cmd>q<CR>]], {})
  vim.keymap.set('n', 'H', [[[b]], { silent = true })
  vim.keymap.set('n', 'L', [[]b]], { silent = true })

  vim.keymap.set('v', '<', [[<gv]])
  vim.keymap.set('v', '>', [[>gv]])

  -- get back to normal mode quickly
  vim.keymap.set('t', '<Esc><Esc>', [[<C-\><C-n>]], { noremap = true })

  -- open NnnPicker a-la vinegar
  vim.keymap.set('n', '-', [[<Cmd>NnnPicker %:p<CR>]], { desc = 'File Picker' })

  vim.keymap.set('n', '<leader>nc', ':<C-u>NoteNew<Space>', { desc = 'Create new note' })
  vim.keymap.set('n', '<leader>nn', ':<C-u>NoteFind<CR>', { desc = 'Open a note' })
  vim.keymap.set('n', '<leader>no', ':<C-u>NoteFind<Space>', { desc = 'Open a note in a subdirectory' })
  vim.keymap.set('n', '<leader>n/', ':<C-u>NoteGrep<CR>', { desc = 'Search all notes' })
  vim.keymap.set('n', '<leader>ns', ':<C-u>NoteGrep<Space>', { desc = 'Search notes in a subdirectory' })
  vim.keymap.set('n', '<leader>nt', '<Cmd>JournalDaily<CR>', { desc = 'Journal today' })
  vim.keymap.set('n', '<leader>nj', '<Cmd>JournalDaily<Space>', { desc = 'Open a specific journal' })
end

-- improve netrw a-la tpope/vim-vinegar
M.netrw = function()
  vim.keymap.set('n', 'q', [[<C-^>]], { buffer = true })
  vim.keymap.set('n', 'h', [[-]], { buffer = true })
  vim.keymap.set('n', 'l', [[<CR>]], { buffer = true })
  vim.keymap.set('n', 't', [[i]], { buffer = true })
  vim.bo.bufhidden = 'wipe'
end

-- lsp maps
M.lsp_on_attach = function(_, bufnr)
  vim.keymap.set('n', 'gr', '<Cmd>Lspsaga rename<CR>', { silent = true, buffer = bufnr })
  vim.keymap.set('n', 'gx', '<Cmd>Lspsaga code_action<CR>', { silent = true, buffer = bufnr })
  vim.keymap.set('x', 'gx', ':<C-u>Lspsaga range_code_action<CR>', { silent = true, buffer = bufnr })
  vim.keymap.set('n', 'K', '<Cmd>Lspsaga hover_doc<CR>', { silent = true, buffer = bufnr })
  vim.keymap.set('n', 'geo', '<Cmd>Lspsaga show_line_diagnostics<CR>', { silent = true, buffer = bufnr })
  vim.keymap.set('n', 'gej', '<Cmd>Lspsaga diagnostic_jump_next<CR>', { silent = true, buffer = bufnr })
  vim.keymap.set('n', 'gek', '<Cmd>Lspsaga diagnostic_jump_prev<CR>', { silent = true, buffer = bufnr })
  vim.keymap.set('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', { silent = true, buffer = bufnr })
end

M.barbar = function()
  vim.keymap.set('n', '[b', [[<Cmd>BufferPrevious<CR>]], { silent = true, desc = 'Buffer previous' })
  vim.keymap.set('n', ']b', [[<Cmd>BufferNext<CR>]], { silent = true, desc = 'Buffer next' })
  vim.keymap.set('n', '[B', [[<Cmd>BufferFirst<CR>]], { silent = true, desc = 'Buffer first' })
  vim.keymap.set('n', ']B', [[<Cmd>BufferLast<CR>]], { silent = true, desc = 'Buffer last' })
end

return M
