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
      exclude_ft = _G.me.o.panels,
      sidebar_filetypes = sidebars,
      auto_hide = 1,
      -- Uncomment to only show pinned tabs:
      -- auto_hide = 0,
      -- hide = {
      --   current = true,
      --   inactive = true,
      --   visible = true,
      -- },
      icons = {
        button = '',
        modified = { button = ' ' },
        pinned = { button = ' ', filename = true },
        separator_at_end = false,
        inactive = { separator = { left = ' ' } },
      },
      diagnostic = {
        [vim.diagnostic.severity.ERROR] = { enabled = true },
      },
      highlight_inactive_file_icons = true,
      maximum_padding = 4,
      minimum_padding = 1,
    }
    require('core/keymaps').barbar()
  end,
}
