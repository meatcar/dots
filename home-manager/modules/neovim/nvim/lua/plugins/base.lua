_G.me.o.sidebars = {
  'NvimTree',
  'qf',
  'vista_kind',
  'terminal',
  'Mundo',
  'trouble',
  'neo-tree',
  'fugitive',
  'sagaoutline'
}

return {
  'nvim-lua/plenary.nvim',                             -- used by neovim packages
  { 'tpope/vim-repeat',                lazy = false }, -- repeat more things
  { 'wellle/targets.vim',              lazy = false }, -- additional text objects
  { 'kopischke/vim-fetch',             lazy = false }, -- handle line and column numbers in file names
  { 'airblade/vim-rooter',             lazy = false }, -- auto-cd to root directory
  { 'Konfekt/FastFold',                lazy = false }, -- speed up folding for big files
  { 'aymericbeaumet/symlink.vim',      lazy = false }, -- follow symlinks
  { 'ConradIrwin/vim-bracketed-paste', lazy = false }, -- better paste in supported terminals
  { 'jghauser/mkdir.nvim',             lazy = false }, -- create directory when :e unknown/paths

  {                                                    -- smartly exit things
    'marklcrns/vim-smartq',
    keys = {
      { 'Q',     'q' },
      { 'q',     '<Plug>(smartq_this)' },
      { '<C-q>', '<Plug>(smartq_this_force)' },
    }
  },

  { -- keep cursor in place when shifting around
    'gbprod/stay-in-place.nvim',
    event = me.o.events.verylazy,
    config = true
  },

  {
    'dstein64/vim-startuptime', -- debug slow vim startup times
    cmd = 'StartupTime',
    config = function()
      vim.g.startuptime_tries = 10
    end,
  },

  { -- strip whitespace on edited lines
    'lewis6991/spaceless.nvim',
    config = true,
  },

  {
    'chrisgrieser/nvim-genghis', -- :Delete, :Move, etc
    config = true,
    cmd = {
      'New', 'Duplicate', 'NewFromSelection', 'Rename', 'Move', 'Trash', 'Chmodx',
      'CopyFilename', 'CopyFilepath', 'CopyDirectoryPath', 'CopyRelativePath', 'CopyRelativeDirectoryPath',
    },
    keys = {
      { '<leader>fn',  '<cmd>New<CR>',                       desc = 'New' },
      { '<leader>fd',  '<cmd>Duplicate<CR>',                 desc = 'Duplicate' },
      { '<leader>fR',  '<cmd>Rename<CR>',                    desc = 'Rename' },
      { '<leader>fm',  '<cmd>Move<CR>',                      desc = 'Move' },
      { '<leader>fT',  '<cmd>Trash<CR>',                     desc = 'Trash' },
      { '<leader>fx',  '<cmd>Chmodx<CR>',                    desc = 'chmod +x' },
      { '<leader>fyn', '<cmd>CopyFilename<CR>',              desc = 'Copy file name' },
      { '<leader>fyp', '<cmd>CopyFilepath<CR>',              desc = 'Copy file path' },
      { '<leader>fyd', '<cmd>CopyDirectoryPath<CR>',         desc = 'Copy directory path' },
      { '<leader>fyr', '<cmd>CopyRelativePath<CR>',          desc = 'Copy relative path' },
      { '<leader>fyR', '<cmd>CopyRelativeDirectoryPath<CR>', desc = 'Copy relative directory path' },
    }
  },

  { -- basics
    'echasnovski/mini.basics',
    version = false,
    event = me.o.events.verylazy,
    opts = {
      options = {
        basic = false,
        extra_ui = false,
        winborders = 'single',
      },
      mappings = {
        basic = true,
        option_toggle_prefix = '<Leader>t',
      },
    },
    config = function(_, opts)
      require('mini.basics').setup(opts)
    end,
  },

  { -- work with surrounding text
    'echasnovski/mini.surround',
    version = false,
    event = me.o.events.verylazy,
    opts = {
      mappings = {
        add = '<leader>sa',            -- Add surrounding in Normal and Visual modes
        delete = '<leader>sd',         -- Delete surrounding
        find = '<leader>sf',           -- Find surrounding (to the right)
        find_left = '<leader>sF',      -- Find surrounding (to the left)
        highlight = '<leader>sh',      -- Highlight surrounding
        replace = '<leader>sr',        -- Replace surrounding
        update_n_lines = '<leader>sn', -- Update `n_lines`
      },
    },
    config = function(_, opts)
      require('mini.surround').setup(opts)
    end,
  },

  { -- [b ]b etc to manipulate nvim
    'echasnovski/mini.bracketed',
    event = me.o.events.verylazy,
    version = false,
    config = function(_, opts)
      require('mini.bracketed').setup(opts)
    end,
    opts = {
      buffer = { suffix = '' }, -- set by barbar.nvim
    },
  },

  { -- jump around
    'ggandor/leap.nvim',
    event = me.o.events.verylazy,
    config = function()
      require('leap').add_default_mappings()
    end,
  },

  { -- easy commenting with gcc
    'numToStr/Comment.nvim',

  { -- add to function blocks
    'RRethy/nvim-treesitter-endwise',
    event = me.o.events.insert,
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('nvim-treesitter.configs').setup {
        endwise = {
          enable = true,
        },
      }
    end,
    keys = { "gc", "gb" },
    main = 'Comment',
    opts = {},
  },

  { -- quickly delete multiple buffers based on the conditions provided
    'kazhala/close-buffers.nvim',
    cmd = { 'BDelete', 'BWipeout' },
    config = function()
      require('close_buffers').setup {
        filetype_ignore = {},                -- Filetype to ignore when running deletions
        preserve_window_layout = { 'this' }, -- Types of deletion that should preserve the window layout
        next_buffer_cmd = function(windows)
          local bufnr = vim.api.nvim_get_current_buf()

          for _, window in ipairs(windows) do
            vim.api.nvim_win_set_buf(window, bufnr)
          end
        end,
      }
    end,
  },

  {
    'windwp/nvim-autopairs',
    event = me.o.events.insert,
    opts = {},
    config = function(_, opts)
      require('nvim-autopairs').setup(opts)
      local cmp_autopairs = require('nvim-autopairs.completion.cmp')
      local cmp = require('cmp')
      cmp.event:on(
        'confirm_done',
        cmp_autopairs.on_confirm_done()
      )
    end
  },
}
