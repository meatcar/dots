return {
  {
    'folke/lazy.nvim',
    keys = {
      { '<leader>vll', '<Cmd>Lazy<CR>',         desc = 'Lazy' },
      { '<leader>vlc', '<Cmd>Lazy clean<CR>',   desc = 'Lazy clean' },
      { '<leader>vlu', '<Cmd>Lazy check<CR>',   desc = 'Lazy check' },
      { '<leader>vlp', '<Cmd>Lazy profile<CR>', desc = 'Lazy profile' },
    },
    init = function()
      require('which-key').register({ ['<leader>vl'] = { name = 'lazy' } })
    end,
  }
}
