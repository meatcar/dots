local M = {}

M.main = function()
  vim.keymap.set('n', 'q:', [[<Cmd>q<CR>]], {})
  vim.keymap.set('n', 'H', [[[b]], { silent = true })
  vim.keymap.set('n', 'L', [[]b]], { silent = true })

  vim.keymap.set('v', '<', [[<gv]])
  vim.keymap.set('v', '>', [[>gv]])

  -- get back to normal mode quickly
  vim.keymap.set('t', '<Esc><Esc>', [[<C-\><C-n>]], { noremap = true })

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
  local function map(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { silent = true, buffer = bufnr, desc = desc })
  end
  local lsp, diag = vim.lsp.buf, vim.diagnostic

  -- core LSP actions (native, Neovim 0.11+)
  map('n', 'gr', lsp.rename, 'Rename')
  map({ 'n', 'x' }, 'gx', lsp.code_action, 'Code action')
  map('n', 'K', lsp.hover, 'Hover doc')
  map('n', 'gd', lsp.definition, 'Definition')

  -- diagnostics (native)
  map('n', 'geo', diag.open_float, 'Line diagnostics')
  map('n', 'gej', function() diag.jump({ count = 1, float = true }) end, 'Next diagnostic')
  map('n', 'gek', function() diag.jump({ count = -1, float = true }) end, 'Prev diagnostic')

  -- <leader>l* lsp group
  map('n', '<leader>lm', lsp.rename, 'Rename')
  map({ 'n', 'x' }, '<leader>la', lsp.code_action, 'Action')
  map('n', '<leader>lh', lsp.hover, 'Hover Doc')
  map('n', '<leader>ls', lsp.signature_help, 'Signature')
  map('n', '<leader>li', diag.open_float, 'Line info')
  map('n', '<leader>lc', function() diag.open_float({ scope = 'cursor' }) end, 'Cursor info')

  -- peek definition/type in a float (goto-preview; replaces lspsaga peek + textobjects lsp_interop)
  local ok, peek = pcall(require, 'goto-preview')
  if ok then
    map('n', '<leader>ld', peek.goto_preview_definition, 'Peek definition')
    map('n', '<leader>df', peek.goto_preview_definition, 'Peek definition')
    map('n', '<leader>dF', peek.goto_preview_type_definition, 'Peek type definition')
  end
end

return M
