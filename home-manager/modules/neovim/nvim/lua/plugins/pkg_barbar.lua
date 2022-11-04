return {
  'romgrk/barbar.nvim',
  requires = { 'kyazdani42/nvim-web-devicons' },
  event = 'ColorScheme', -- hack, delay bufferline until a colorscheme is set
  setup = function()
    vim.g.bufferline = vim.g.bufferline or {}
    vim.g.bufferline.auto_hide = false
    vim.g.bufferline.closeable = false
  end,
  config = function()
    vim.keymap.set('n', '[b', [[<Cmd>BufferPrev<CR>]], { silent = true })
    vim.keymap.set('n', ']b', [[<Cmd>BufferNext<CR>]], { silent = true })
  end,
}
