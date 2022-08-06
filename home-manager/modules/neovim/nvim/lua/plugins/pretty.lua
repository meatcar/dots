return function(use)
  use 'kien/rainbow_parentheses.vim'

  use 'xtal8/traces.vim'

  use 'romainl/vim-cool' -- smart set nohl after we're done searching

  use { -- smooth scrolling
    'karb94/neoscroll.nvim',
    config = function()
      require('neoscroll').setup()
    end,
  }

  use { -- flash cursor sometimes
    'edluffy/specs.nvim',
    config = function()
      require('specs').setup {
        show_jumps = true,
        min_jump = 30,
        popup = {
          delay_ms = 0, -- delay before popup displays
          inc_ms = 10, -- time increments used for fade/resize effects
          blend = 10, -- starting blend, between 0-100 (fully transparent), see :h winblend
          width = 10,
          winhl = 'PMenu',
          fader = require('specs').linear_fader,
          resizer = require('specs').shrink_resizer,
        },
        ignore_filetypes = {},
        ignore_buftypes = {
          nofile = true,
        },
      }
    end,
  }

  use { -- highlight word under cursor
    'RRethy/vim-illuminate',
    config = function()
      vim.g.Illuminate_ftblacklist = _G.me.o.sidebars
      vim.api.nvim_set_keymap(
        'n',
        '<a-n>',
        '<cmd>lua require"illuminate".next_reference{wrap=true}<cr>',
        { noremap = true }
      )
      vim.api.nvim_set_keymap(
        'n',
        '<a-p>',
        '<cmd>lua require"illuminate".next_reference{reverse=true,wrap=true}<cr>',
        { noremap = true }
      )
      function _G.me.fn.illuminate_lsp_on_attach(client, _)
        require('illuminate').on_attach(client)
      end
    end,
  }

  use { -- pretty fold texts
    'jrudess/vim-foldtext',
    config = function()
      vim.g.FoldText_line = '' -- 
      vim.g.FoldText_multiplication = ' '
    end,
  }

  use { -- eol hints & counters when searching
    'kevinhwang91/nvim-hlslens',
    config = function()
      for _, map in ipairs { 'n', 'N' } do
        vim.api.nvim_set_keymap(
          'n',
          map,
          [[<cmd>execute('normal! ' . v:count1 . ']] .. map .. [[')<cr><cmd>lua require('hlslens').start()<cr>]],
          { noremap = true, silent = true }
        )
      end
      for _, map in ipairs { '*', '#', 'g*', 'g#' } do
        vim.api.nvim_set_keymap('n', map, map .. [[<cmd>lua require('hlslens').start()<cr>]], { noremap = true })
      end
    end,
  }

  use { -- notifications
    'rcarriga/nvim-notify',
    config = function()
      vim.notify = require 'notify'
    end,
  }
end
