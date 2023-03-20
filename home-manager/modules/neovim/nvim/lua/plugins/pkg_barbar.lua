return {
  'romgrk/barbar.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    require('bufferline').setup {
      animation = false,
      auto_hide = true,
      closable = false,
      exclude_ft = _G.me.o.sidebars,
      icon_pinned = '車',
    }
    require('core/keymaps').barbar()
  end,
}
