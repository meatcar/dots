return {
  { 'nvim-tree/nvim-web-devicons' },

  { 'xtal8/traces.vim',           event = me.o.events.insert },
  { 'romainl/vim-cool',           event = me.o.events.buf_late }, -- smart set nohl after we're done searching
  { 'Bekaboo/deadcolumn.nvim',    event = me.o.events.buf_late }, -- gradually show colorcolumn

  {
    'HiPhish/rainbow-delimiters.nvim',
    event = me.o.events.buf_early,
    keys = { { '<leader>tp', function() require('rainbow-delimiters').toggle() end, desc = 'Rainbow parens' } },
    config = function()
      local rainbow = require 'rainbow-delimiters'

      vim.g.rainbow_delimiters = {
        strategy = {
          [''] = rainbow.strategy['global'],
          commonlisp = rainbow.strategy['local'],
          html = rainbow.strategy['local'],
        },
        query = {
          [''] = 'rainbow-delimiters',
          lua = 'rainbow-blocks',
          elixir = 'rainbow-blocks',
          javascript = 'rainbow-delimiters-react',
        },
        highlight = {
          'RainbowDelimiterRed',
          'RainbowDelimiterYellow',
          'RainbowDelimiterBlue',
          'RainbowDelimiterOrange',
          'RainbowDelimiterGreen',
          'RainbowDelimiterViolet',
          'RainbowDelimiterCyan',
        },
        blacklist = { 'c', 'cpp' },
      }
    end
  },

  { -- better vim.ui
    'stevearc/dressing.nvim',
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function(...)
        require('lazy').load { plugins = { 'dressing.nvim' } }
        return vim.ui.select(...)
      end
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.input = function(...)
        require('lazy').load { plugins = { 'dressing.nvim' } }
        return vim.ui.input(...)
      end
    end,
  },

  { -- smooth scrolling
    'karb94/neoscroll.nvim',
    event = me.o.events.verylazy,
    opts = {
      -- All these keys will be mapped to their corresponding default scrolling animation
      mappings = { '<C-u>', '<C-d>', '<C-b>', '<C-f>', '<C-y>', '<C-e>', 'zt', 'zz', 'zb' },
      easing_function = 'circular',
      hide_cursor = true,
    },
  },

  { -- flash cursor sometimes
    'edluffy/specs.nvim',
    event = me.o.events.verylazy,
    config = function()
      require('specs').setup {
        show_jumps = true,
        min_jump = 30,
        popup = {
          delay_ms = 0, -- delay before popup displays
          inc_ms = 10,  -- time increments used for fade/resize effects
          blend = 10,   -- starting blend, between 0-100 (fully transparent), see :h winblend
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
  },

  { -- highlight word under cursor
    'RRethy/vim-illuminate',
    event = me.o.events.buf_late,
    config = function()
      vim.g.Illuminate_ftblacklist = _G.me.o.sidebars
      vim.keymap.set('n', '<a-n>', '<cmd>lua require"illuminate".next_reference{wrap=true}<cr>')
      vim.keymap.set('n', '<a-p>',
        '<cmd>lua require"illuminate".next_reference{reverse=true,wrap=true}<cr>')
    end,
  },

  {
    'kevinhwang91/nvim-ufo',
    dependencies = { 'kevinhwang91/promise-async', 'nvim-treesitter/nvim-treesitter' },
    event = me.o.events.verylazy,
    config = function()
      vim.o.foldcolumn = '1'
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
      vim.opt.fillchars:append { eob = ' ', fold = ' ', foldopen = '-', foldsep = ' ', foldclose = '+' }

      vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
      vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)

      ---@diagnostic disable-next-line: missing-fields
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
                suffix = table.concat { suffix, (' '):rep(targetWidth -
                  curWidth - chunkWidth) }
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
  },

  { -- eol hints & counters when searching
    'kevinhwang91/nvim-hlslens',
    event = me.o.events.verylazy,
    keys = function(_plugin, keys)
      for _, map in ipairs { 'n', 'N' } do
        table.insert(keys, {
          map,
          ([[<cmd>execute('normal! ' . v:count1 . '%s')<cr><cmd>lua require('hlslens').start()<cr>]])
              :format(map),
          silent = true
        })
      end

      for _, map in ipairs { '*', '#', 'g*', 'g#' } do
        table.insert(keys, {
          map,
          ([[%s<cmd>lua require('hlslens').start()<cr>]]):format(map)
        })
      end

      return keys
    end,
    config = function()
      require('hlslens').setup()
    end,
  },

  {
    'dstein64/nvim-scrollview', -- scroll bar
    event = me.o.events.buf_late,
    opts = {
      excluded_filetypes = _G.me.o.sidebars,
      current_only = true,
      winblend = 75,
      base = 'right',
    },
  },

  {
    'luukvbaal/statuscol.nvim',
    version = false,
    event = me.o.events.verylazy,
    config = function()
      local builtin = require 'statuscol.builtin'
      require('statuscol').setup {
        ft_ignore = _G.me.o.sidebars,
        segments = {
          {
            sign = { name = { '.*' }, maxwidth = 2, colwidth = 2, auto = true },
            click = 'v:lua.ScSa',
          },
          { text = { builtin.foldfunc }, click = 'v:lua.ScFa' },
          { text = { builtin.lnumfunc }, click = 'v:lua.ScLa' },
          {
            sign = { name = { 'GitSigns*' }, maxwidth = 2, colwidth = 1, auto = true },
            click = 'v:lua.ScSa',
          },
        },
      }
    end,
  },

}
