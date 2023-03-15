_G.me.o.sidebars = { 'NvimTree', 'qf', 'vista_kind', 'terminal', 'Mundo', 'trouble' }

return {
  'nvim-lua/plenary.nvim', -- used by neovim packages
  'tpope/vim-eunuch', -- :Delete, :Move, etc
  'tpope/vim-repeat', -- repeat more things
  'wellle/targets.vim', -- additional text objects
  'pbrisbin/vim-mkdir', -- create directory when :e unknown/paths
  -- 'kopischke/vim-stay', -- save fold states
  'kopischke/vim-fetch', -- handle line and column numbers in file names
  'airblade/vim-rooter', -- auto-cd to root directory
  'Konfekt/FastFold', -- speed up folding for big files
  'aymericbeaumet/symlink.vim', -- follow symlinks
  'ConradIrwin/vim-bracketed-paste', -- better paste in supported terminals
  'tweekmonster/startuptime.vim', -- debug slow vim startup times
  'lewis6991/impatient.nvim', -- cache lua compiled modules
  'axelf4/vim-strip-trailing-whitespace', -- strip whitespace on edited lines

  { -- basics
    'echasnovski/mini.basics',
    version = false,
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
    opts = {
      mappings = {
        add = '<leader>sa', -- Add surrounding in Normal and Visual modes
        delete = '<leader>sd', -- Delete surrounding
        find = '<leader>sf', -- Find surrounding (to the right)
        find_left = '<leader>sF', -- Find surrounding (to the left)
        highlight = '<leader>sh', -- Highlight surrounding
        replace = '<leader>sr', -- Replace surrounding
        update_n_lines = '<leader>sn', -- Update `n_lines`
      },
    },
    config = function(_, opts)
      require('mini.surround').setup(opts)
    end,
  },

  { -- [b ]b etc to manipulate nvim
    'echasnovski/mini.bracketed',
    version = false,
    config = function(_, opts)
      require('mini.bracketed').setup(opts)
    end,
  },

  {
    'ggandor/leap.nvim',
    config = function()
      require('leap').add_default_mappings()
    end,
  },

  { --easy commenting with gcc
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup()
    end,
  },

  { -- add  to function blocks
    'RRethy/nvim-treesitter-endwise',
    config = function()
      require('nvim-treesitter.configs').setup {
        endwise = {
          enable = true,
        },
      }
    end,
  },

  { -- quickly delete multiple buffers based on the conditions provided
    'kazhala/close-buffers.nvim',
    config = function()
      require('close_buffers').setup {
        filetype_ignore = {}, -- Filetype to ignore when running deletions
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
  },
}
