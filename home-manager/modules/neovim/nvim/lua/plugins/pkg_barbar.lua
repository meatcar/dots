return {
  'romgrk/barbar.nvim',
  event = me.o.events.verylazy,
  keys = {
    { '<leader>bB', '<Cmd>BufferPick<CR>',                       desc = 'Bufferline Pick' },
    { '<leader>bd', '<Cmd>BufferClose<CR>',                      desc = 'Delete' },
    { '<leader>bD', '<Cmd>BufferCloseAllButCurrentOrPinned<CR>', desc = 'Purge' },
    { '<leader>bn', ']b',                                        desc = 'Next' },
    { '<leader>bp', '[b',                                        desc = 'Prev' },
    { '<leader>bi', '<Cmd>BufferPin<CR>',                        desc = 'Pin' },
    { '<leader>bN', '<Cmd>BufferMoveNext<CR>',                   desc = 'Move right' },
    { '<leader>bP', '<Cmd>BufferMovePrev<CR>',                   desc = 'Move left' },
    { ']B',         '<Cmd>BufferMoveNext<CR>', },
    { '[B',         '<Cmd>BufferMovePrev<CR>', },
    { ']b',         '<Cmd>BufferNext<CR>', },
    { '[b',         '<Cmd>BufferPrev<CR>', },
  },
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
      focus_on_close = 'previous',
    }
  end,
}
