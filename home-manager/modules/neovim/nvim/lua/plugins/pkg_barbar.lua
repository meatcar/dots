return {
  'romgrk/barbar.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    require('bufferline').setup {
      animation = false,
      auto_hide = true,
      closable = false,
      exclude_ft = _G.me.o.sidebars,
    }
    vim.keymap.set('n', '[b', [[<Cmd>BufferPrev<CR>]], { silent = true })
    vim.keymap.set('n', ']b', [[<Cmd>BufferNext<CR>]], { silent = true })
  end,
}
