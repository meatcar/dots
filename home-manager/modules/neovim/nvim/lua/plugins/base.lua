_G.me.o.panels = {
  'Mundo',
  'NeogitStatus',
  'NvimTree',
  'fugitive',
  'neo-tree',
  'qf',
  'sagaoutline',
  'terminal',
  'trouble',
  'vista_kind',
}

_G.me.o.sidebars = {
  'Mundo',
  'NvimTree',
  'neo-tree',
  'sagaoutline',
  'vista_kind',
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

  {
    'nmac427/guess-indent.nvim', -- guess indent
    lazy = false,
    opts = {}
  },

  { -- smartly exit things
    'marklcrns/vim-smartq',
    keys = {
      { 'Q',     'q' },
      { 'q',     '<Plug>(smartq_this)' },
      { '<C-q>', '<Plug>(smartq_this_force)' },
    },
    init = function()
      vim.g.smartq_default_mappings = false
      vim.g.smartq_q_buftypes = { 'quickfix' }
      vim.g.smartq_auto_close_splits = true
    end
  },

  { -- keep cursor in place when shifting around
    'gbprod/stay-in-place.nvim',
    event = me.o.events.verylazy,
    opts = {}
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
    opts = {},
  },

  {
    'chrisgrieser/nvim-genghis', -- :Delete, :Move, etc
    opts = {},
    keys = {
      { '<leader>fn',  '<cmd>Genghis createNewFile<CR>',             desc = 'Create New File' },
      { '<leader>fd',  '<cmd>Genghis duplicateFile<CR>',             desc = 'Duplicate File' },
      { '<leader>fR',  '<cmd>Genghis renameFile<CR>',                desc = 'Rename File' },
      { '<leader>fm',  '<cmd>Genghis moveAndRenameFile<CR>',         desc = 'Move and Rename File' },
      { '<leader>fT',  '<cmd>Genghis trashFile<CR>',                 desc = 'Trash File' },
      { '<leader>fx',  '<cmd>Genghis chmodx<CR>',                    desc = 'chmod +x' },
      { '<leader>fyn', '<cmd>Genghis copyFilename<CR>',              desc = 'Copy file name' },
      { '<leader>fyp', '<cmd>Genghis copyFilepath<CR>',              desc = 'Copy file path' },
      { '<leader>fyd', '<cmd>Genghis copyDirectoryPath<CR>',         desc = 'Copy directory path' },
      { '<leader>fyr', '<cmd>Genghis copyRelativePath<CR>',          desc = 'Copy relative path' },
      { '<leader>fyR', '<cmd>Genghis copyRelativeDirectoryPath<CR>', desc = 'Copy relative directory path' },
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

  -- FIXME: overrides ]c/[c for diff jumps
  -- { -- [b ]b etc to manipulate nvim
  --   'echasnovski/mini.bracketed',
  --   event = me.o.events.verylazy,
  --   version = false,
  --   keys = {
  --     { "[",      "<Cmd>WhichKey [<CR>" },
  --     { "]",      "<Cmd>WhichKey ]<CR>" },
  --     { "[<Tab>", "<Cmd>tabprevious<CR>" },
  --     { "]<Tab>", "<Cmd>tabnext<CR>" },
  --   },
  --   config = function(_, opts)
  --     require('mini.bracketed').setup(opts)
  --   end,
  --   opts = {
  --     buffer = { suffix = '' }, -- set by barbar.nvim
  --   },
  -- },

  { -- jump around
    'ggandor/leap.nvim',
    event = me.o.events.verylazy,
    config = function()
      require('leap').add_default_mappings()
    end,
  },

  { -- easy commenting with gcc
    'numToStr/Comment.nvim',
    keys = {
      { "gc", mode = { 'n', 'v' } },
      { "gb", mode = { 'n', 'v' } },
    },
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
    opts = { fast_wrap = {} },
    config = true
  },
}
