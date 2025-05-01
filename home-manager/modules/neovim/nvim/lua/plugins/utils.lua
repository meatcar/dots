return {
  { -- mass-edit lines in quickfix
    'Olical/vim-enmasse',
    cmd = 'EnMasse',
  },
  { -- better quickfix window
    'kevinhwang91/nvim-bqf',
    ft = 'qf',
    opts = {
      func_map = { tabc = '' }
    }
  },
  { 'kshenoy/vim-signature', event = me.o.events.verylazy }, -- show marks in the SignColumn
  { 'lambdalisue/suda.vim',  cmd = 'SudaWrite' },            -- save file with sudo

  {                                                          -- run tests easily
    'janko/vim-test',
    keys = {
      { '<leader>rtt', '<Cmd>TestNearest<CR>', desc = 'Nearest' },
      { '<leader>rtf', '<Cmd>TestFile<CR>',    desc = 'File' },
      { '<leader>rts', '<Cmd>TestSuite<CR>',   desc = 'Suite' },
      { '<leader>rtr', '<Cmd>TestLast<CR>',    desc = 'Recent' },
      { '<leader>rtg', '<Cmd>TestVisit<CR>',   desc = 'Goto' },
    },
    init = function()
      require('which-key').add({ '<leader>rt', group = 'test' })
    end,
    config = function()
      if vim.env.TMUX ~= nil then
        vim.g['test#strategy'] = 'vimux'
      end
      vim.g['test#preserve_screen'] = false
    end,
  },

  { -- undo tree
    'simnalamburt/vim-mundo',
    cmd = 'MundoToggle',
    keys = { { '<leader>ou', '<cmd>MundoToggle<CR>', desc = 'Undo Tree' } }
  },

  { -- align operations
    'junegunn/vim-easy-align',
    cmd = { 'EasyAlign', 'LiveEasyAlign' },
    keys = {
      -- Start interactive EasyAlign in visual mode (e.g. vipga)
      -- Start interactive EasyAlign for a motion/text object (e.g. gaip)
      { 'ga', '<Plug>(EasyAlign)', mode = { 'n', 'x' } },
    }
  },

  { -- UI for dadbod, a database UI
    'kristijanhusak/vim-dadbod-ui',
    dependencies = {
      { 'tpope/vim-dadbod' },
      { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' } },
    },
    cmd = { 'DBUI', 'DBUIToggle', 'DBUIAddConnection', 'DBUIFindBuffer', },
    init = function()
      vim.g.db_ui_use_nerd_fonts = true
    end,
  },

  -- {
  --   'luukvbaal/nnn.nvim',
  --   cmd = { 'NnnExplorer', 'NnnPicker' },
  --   opts = {
  --     explorer = { cmd = 'nnn -C -G' },
  --     picker = { cmd = 'nnn -G -C', style = { border = 'rounded' } },
  --     replace_netrw = 'picker',
  --   },
  -- },
  {
    'mikavilpas/yazi.nvim',
    keys = {
      {
        '-', '<cmd>Yazi<CR>', desc = "Open Yazi file manager"
      }

    }
  },

  { -- ctrl-[ax] on drugs
    'zegervdv/nrpattern.nvim',
    keys = { '<C-a>', '<C-x>' },
    config = function()
      -- Get the default dict of patterns
      local patterns = require 'nrpattern.default'

      -- Add a cyclic pattern (toggles between yes and no)
      patterns[{ 'yes', 'no' }] = { priority = 10 }
      patterns[{ 'True', 'False' }] = { priority = 10 }
      patterns[{ '[ ]', '[x]', '[-]' }] = { priority = 10 }
      patterns[{ 'TODO', 'DONE', 'FIX', 'NOTE', 'WARN', 'TEST', 'HACK', 'WARN', 'PERF' }] = { priority = 10 }

      -- Call the setup to enable the patterns
      require('nrpattern').setup(patterns)
    end,
  },

  { -- show lines for indents on blank lines
    'lukas-reineke/indent-blankline.nvim',
    event = me.o.events.buf_early,
    keys = { { '<leader>tI', '<cmd>IBLToggle<CR>', desc = 'Indent highlight' } },
    main = 'ibl',
    opts = {
      enabled = true,
      indent = {
        char = { '¦', '┆', '┊', '▏' },
      },
      whitespace = { remove_blankline_trail = true },
      exclude = { filetypes = _G.me.o.panels },
    }
  },

  { -- highlight and add UI for #TODO comments
    'folke/todo-comments.nvim',
    event = me.o.events.buf_early,
    keys = { { '<leader>ot', '<cmd>TodoTelescope<CR>', desc = 'TODO' } },
    opts = { signs = false },
  },

  { -- tmux integration
    'aserowy/tmux.nvim',
    event = me.o.events.verylazy,
    cond = function()
      return vim.env.TMUX ~= nil
    end,
    main = 'tmux',
    opts = {
      copy_sync = { enable = true },
      navigation = { enable_default_keybindings = true },
      resize = { enable_default_keybindings = true },
    }
  },

  { -- open and run commands in a tmux pane
    'preservim/vimux',
    event = me.o.events.verylazy,
    keys = {
      { '<leader>rrp', '<Cmd>VimuxPromptCommand<CR>',       desc = 'Prompt' },
      { '<leader>rrr', '<Cmd>VimuxRunLastCommand<CR>',      desc = 'Last' },
      { '<leader>rri', '<Cmd>VimuxInspectRunner<CR>',       desc = 'Inspect' },
      { '<leader>rro', '<Cmd>VimuxOpenRunner<CR>',          desc = 'Open' },
      { '<leader>rrq', '<Cmd>VimuxCloseRunner<CR>',         desc = 'Close' },
      { '<leader>rrd', '<Cmd>VimuxCloseRunner<CR>',         desc = 'Close' },
      { '<leader>rrs', '<Cmd>VimuxInterruptRunner<CR>',     desc = 'Interrupt (stop)' },
      { '<leader>rrc', '<Cmd>VimuxInterruptRunner<CR>',     desc = 'Interrupt (cancel)' },
      { '<leader>rrl', '<Cmd>VimuxClearTerminalScreen<CR>', desc = 'Clear' },
      { '<leader>rrz', '<Cmd>VimuxZoomRunner<CR>',          desc = 'Zoom' },
    },
    init = function()
      require('which-key').add({ '<leader>rr', group = 'command' })
    end,
    cond = function()
      return vim.env.TMUX ~= nil
    end,
  },

  { -- fullscreen current buffer
    'folke/zen-mode.nvim',
    cmd = 'ZenMode',
    keys = {
      { '<C-w>z',     '<Cmd>ZenMode<CR>', desc = "Zen Mode" },
      { '<leader>wz', '<Cmd>ZenMode<CR>', desc = "Zen Mode" },
    },
    opts = {}
  },

  { -- color highlighter
    'norcalli/nvim-colorizer.lua',
    event = me.o.events.verylazy,
    config = function()
      require('colorizer').setup()
    end,
  },

  { -- split/join code using treesitter
    'Wansmer/treesj',
    keys = {
      {
        '<localleader>jj',
        function()
          require('treesj').toggle()
        end,
        desc = 'split/join toggle',
      },
      {
        '<localleader>jS',
        function()
          require('treesj').split()
        end,
        desc = 'split',
      },
      {
        '<localleader>jJ',
        function()
          require('treesj').join()
        end,
        desc = 'join',
      },
    },
    opts = { use_default_keymaps = false },
  },

  { -- open browser with various queries
    'lalitmee/browse.nvim',
    keys = {
      { '<leader>obb', function() require('browse').browse() end,                       desc = 'Browse' },
      { '<leader>obs', function() require('browse').input_search() end,                 desc = 'Search' },
      { '<leader>obd', function() require('browse.devdocs').search() end,               desc = 'DevDocs' },
      { '<leader>obD', function() require('browse.devdocs').search_with_filetype() end, desc = 'DevDocs Filetype' },
      { '<leader>obm', function() require('browse.mdn').search() end,                   desc = 'MDN' },
    },
    opts = {
      provider = 'duckduckgo'
    },
  },
  {
    'obsidian-nvim/obsidian.nvim',
    cmd = {
      'Obsidian'
    },
    keys = {
      { '<leader>ny', '<Cmd>Obsidian yesterday<CR>',  desc = 'Journal yesterday' },
      { '<leader>nl', '<Cmd>Obsidian linknew<Space>', desc = 'Link to a note' },
    },
    opts = {
      dir = vim.fn.environ().NOTES_DIR,
      daily_notes = {
        folder = "journal/daily",
        workdays_only = false,
      },
      mappings = {
        -- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
        ["gf"] = {
          action = function() return require("obsidian").util.gf_passthrough() end,
          opts = { noremap = false, expr = true, buffer = true },
        }
      },
      completion = {
        blink = true,
      },
      note_id_func = require('core/notes').notename,
      templates = {
        folder = "templates",
        date_format = "%Y-%m-%d",
        time_format = "%H:%M",
      },
      picker = {
        name = "telescope.nvim"
      }
    }
  },

  {
    'kkoomen/vim-doge',
    build = ':call doge#install()',
    keys = {
      { '<leader>rd', '<Plug>(doge-generate)', desc = 'Generate documentation' }
    },
    init = function()
      vim.g.doge_javascript_settings = {
        destructuring_props = true,
        omit_redundant_param_types = true,
      }
    end,
  },
}
