return function(use)
  use 'kien/rainbow_parentheses.vim'

  use 'xtal8/traces.vim'

  use 'romainl/vim-cool' -- smart set nohl after we're done searching

  use { -- smooth scrolling
    'karb94/neoscroll.nvim',
    config = function()
      require('neoscroll').setup {
        -- All these keys will be mapped to their corresponding default scrolling animation
        mappings = { '<C-u>', '<C-d>', '<C-b>', '<C-f>', '<C-y>', '<C-e>', 'zt', 'zz', 'zb' },
        easing_function = 'circular',
      }
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
      vim.keymap.set('n', '<a-n>', '<cmd>lua require"illuminate".next_reference{wrap=true}<cr>')
      vim.keymap.set('n', '<a-p>', '<cmd>lua require"illuminate".next_reference{reverse=true,wrap=true}<cr>')
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
      require('hlslens').setup()

      for _, map in ipairs { 'n', 'N' } do
        vim.keymap.set(
          'n',
          map,
          [[<cmd>execute('normal! ' . v:count1 . ']] .. map .. [[')<cr><cmd>lua require('hlslens').start()<cr>]],
          { silent = true }
        )
      end

      for _, map in ipairs { '*', '#', 'g*', 'g#' } do
        vim.keymap.set('n', map, map .. [[<cmd>lua require('hlslens').start()<cr>]])
      end
    end,
  }

  use {
    'dstein64/nvim-scrollview', -- scroll bar
    config = function()
      require('scrollview').setup {
        excluded_filetypes = _G.me.o.sidebars,
        current_only = true,
        winblend = 75,
        base = 'right',
      }
    end,
  }

  use { -- improve nvim ui
    'folke/noice.nvim',
    config = function()
      require('noice').setup {
        require('noice').setup {
          lsp = {
            -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
            override = {
              ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
              ['vim.lsp.util.stylize_markdown'] = true,
              ['cmp.entry.get_documentation'] = true,
            },
          },
          -- you can enable a preset for easier configuration
          presets = {
            -- bottom_search = true, -- use a classic bottom cmdline for search
            command_palette = true, -- position the cmdline and popupmenu together
            long_message_to_split = true, -- long messages will be sent to a split
            inc_rename = false, -- enables an input dialog for inc-rename.nvim
            lsp_doc_border = false, -- add a border to hover docs and signature help
          },
        },
      }
    end,
    requires = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      'MunifTanjim/nui.nvim',
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      {
        'rcarriga/nvim-notify',
        config = function()
          require('notify').setup {
            background_colour = '#000000',
            render = 'compact',
          }
        end,
      },
    },
  }
end
