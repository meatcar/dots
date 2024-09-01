return {
  {
    'rcarriga/nvim-notify',
    event = me.o.events.verylazy,
    keys = {
      {
        '<leader>vnd',
        function()
          require('notify').dismiss { silent = true, pending = true }
        end,
        desc = 'Dismiss',
      },
      { '<leader>vnn', '<cmd>Telescope notify<CR>', desc = 'History' },
      { '<leader>on',  '<cmd>Telescope notify<CR>', desc = 'Notifications' }
    },
    init = function()
      require('which-key').add({ '<leader>vn', group = 'notifications' })
    end,
    opts = {
      background_colour = '#000000',
      render = 'compact',
    },
    config = function(_, opts)
      local notify = require 'notify'
      notify.setup(opts)
      vim.notify = notify
    end,
  },

}
