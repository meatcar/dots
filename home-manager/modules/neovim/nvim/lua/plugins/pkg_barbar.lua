return {
  'romgrk/barbar.nvim',
  event = 'VeryLazy',
  config = function()
    require('bufferline').setup {
      animation = false,
      auto_hide = true,
      exclude_ft = _G.me.o.sidebars,
      icons = {
        button = '',
        modified = { button = '' },
        pinned = { button = '車' },
      },
      diagnostic = {
        [vim.diagnostic.severity.ERROR] = { enabled = true },
      },
      highlight_inactive_file_icons = true,
    }
    require('core/keymaps').barbar()
  end,
}
