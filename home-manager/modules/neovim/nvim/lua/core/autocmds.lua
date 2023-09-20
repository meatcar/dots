local M = {}

M.main = function()
  vim.api.nvim_create_augroup('me', { clear = true })
  vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
    group = 'me',
    pattern = '/*/home-manager/modules/neovim/nvim/lua/*.lua',
    callback = function(e)
      require('core/functions').reload_nvim_config(e)
    end,
  })

  -- cursorline in focused windows
  vim.api.nvim_create_autocmd({ 'WinEnter', 'BufEnter' }, {
    group = 'me',
    pattern = '*',
    callback = function(e)
      vim.opt_local.cursorline = true
    end,
  })
  vim.api.nvim_create_autocmd({ 'WinLeave', 'BufLeave' }, {
    group = 'me',
    pattern = '*',
    callback = function(e)
      vim.opt_local.cursorline = false
    end,
  })

  -- Fix old themes colouring SignColumn an ugly grey:
  -- vim.cmd [[ autocmd vimrc ColorScheme * hi clear SignColumn \| hi! link SignColumn LineNr ]]

  -- spelling
  vim.api.nvim_create_autocmd({ 'FileType' }, {
    group = 'me',
    pattern = { 'md', 'markdown', 'mail' },
    callback = function(e)
      vim.opt_local.spell = true
    end,
  })

  -- fix neogit treesitter warning (see https://github.com/NeogitOrg/neogit/issues/405)
  vim.api.nvim_create_autocmd("FileType", {
    group = "me",
    pattern = "NeogitCommitMessage",
    command = "silent! set filetype=gitcommit",
  })

  -- terminal
  vim.cmd [[ autocmd me TermOpen term://* startinsert ]]
  vim.cmd [[ autocmd me TermClose term://* bdelete! ]]

  vim.cmd [[ autocmd me BufEnter *.env{,.*} lua vim.diagnostic.disable(0)]]

  vim.cmd [[ autocmd me FileType netrw lua require('core/keymaps').netrw() ]]

  vim.cmd [[ autocmd me FileType help lua vim.treesitter.start() ]]
end

return M
