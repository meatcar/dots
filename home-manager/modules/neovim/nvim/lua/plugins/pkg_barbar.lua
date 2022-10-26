return {
  'romgrk/barbar.nvim',
  requires = { 'kyazdani42/nvim-web-devicons' },
  config = function()
    -- require('bufferline').setup {}

    vim.keymap.set('n', '[b', [[<Cmd>BufferPrev<CR>]], { silent = true })
    vim.keymap.set('n', ']b', [[<Cmd>BufferNext<CR>]], { silent = true })
  end,
}
