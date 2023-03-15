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
  --
  -- use { -- pretty fold texts
  --   'jrudess/vim-foldtext',
  --   config = function()
  --     vim.g.FoldText_line = '' -- 
  --     vim.g.FoldText_multiplication = ' '
  --   end,
  -- }

  use {
    'kevinhwang91/nvim-ufo',
    requires = 'kevinhwang91/promise-async',
    config = function()
      vim.o.foldcolumn = '1'
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
      vim.o.fillchars = [[eob: ,fold: ,foldopen:-,foldsep: ,foldclose:+]]

      vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
      vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)

      require('ufo').setup {
        provider_selector = function()
          return { 'treesitter', 'indent' }
        end,
        fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
          local newVirtText = {}
          local suffix = ('  %d '):format(endLnum - lnum)
          local sufWidth = vim.fn.strdisplaywidth(suffix)
          local targetWidth = width - sufWidth
          local curWidth = 0
          for _, chunk in ipairs(virtText) do
            local chunkText = chunk[1]
            local chunkWidth = vim.fn.strdisplaywidth(chunkText)
            if targetWidth > curWidth + chunkWidth then
              table.insert(newVirtText, chunk)
            else
              chunkText = truncate(chunkText, targetWidth - curWidth)
              local hlGroup = chunk[2]
              table.insert(newVirtText, { chunkText, hlGroup })
              chunkWidth = vim.fn.strdisplaywidth(chunkText)
              -- str width returned from truncate() may less than 2nd argument, need padding
              if curWidth + chunkWidth < targetWidth then
                suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
              end
              break
            end
            curWidth = curWidth + chunkWidth
          end
          table.insert(newVirtText, { suffix, 'UfoFoldedEllipsis' })
          return newVirtText
        end,
      }
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

  use {
    'rcarriga/nvim-notify',
    config = function()
      require('notify').setup {
        background_colour = '#000000',
        render = 'compact',
      }
    end,
  }

  use {
    'luukvbaal/statuscol.nvim',
    config = function()
      require('statuscol').setup {
        setopt = false,
        ft_ignore = _G.me.o.sidebars,
      }
    end,
  }
end
