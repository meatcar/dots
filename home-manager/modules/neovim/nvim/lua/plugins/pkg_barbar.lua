return {
  'romgrk/barbar.nvim',
  event = me.o.events.verylazy,
  config = function()
    local sidebars = {}
    for _, ft in pairs(_G.me.o.sidebars) do
      if ft == 'neo-tree' then
        sidebars[ft] = { event = 'BufWipeout' }
      else
        sidebars[ft] = true
      end
    end
    require('bufferline').setup {
      animation = false,
      auto_hide = true,
      exclude_ft = _G.me.o.panels,
      sidebar_filetypes = sidebars,
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
