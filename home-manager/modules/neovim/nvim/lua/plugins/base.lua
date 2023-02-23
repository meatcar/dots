_G.me.o.sidebars = { 'NvimTree', 'qf', 'vista_kind', 'terminal', 'packer', 'Mundo' }

return function(use)
  use 'wbthomason/packer.nvim' -- manage self
  use 'nvim-lua/plenary.nvim' -- used by neovim packages
  use 'tpope/vim-eunuch' -- :Delete, :Move, etc
  use 'tpope/vim-repeat' -- repeat more things
  use 'wellle/targets.vim' -- additional text objects
  use 'pbrisbin/vim-mkdir' -- create directory when :e unknown/paths
  -- use 'kopischke/vim-stay' -- save fold states
  use 'kopischke/vim-fetch' -- handle line and column numbers in file names
  use 'airblade/vim-rooter' -- auto-cd to root directory
  use 'Konfekt/FastFold' -- speed up folding for big files
  use 'aymericbeaumet/symlink.vim' -- follow symlinks
  use 'ConradIrwin/vim-bracketed-paste' -- better paste in supported terminals
  use 'tweekmonster/startuptime.vim' -- debug slow vim startup times
  use 'lewis6991/impatient.nvim' -- cache lua compiled modules
  use 'axelf4/vim-strip-trailing-whitespace' -- strip whitespace on edited lines

  use { -- basis
    'echasnovski/mini.basics',
    config = function()
      require('mini.basics').setup {
        options = {
          basic = false,
          extra_ui = false,
          winborders = 'single',
        },
        mappings = {
          basic = true,
          option_toggle_prefix = '<Leader>t',
        },
      }
    end,
  }

  use { -- work with surrounding text
    'echasnovski/mini.surround',
    config = function()
      require('mini.surround').setup {
        mappings = {
          add = '<leader>sa', -- Add surrounding in Normal and Visual modes
          delete = '<leader>sd', -- Delete surrounding
          find = '<leader>sf', -- Find surrounding (to the right)
          find_left = '<leader>sF', -- Find surrounding (to the left)
          highlight = '<leader>sh', -- Highlight surrounding
          replace = '<leader>sr', -- Replace surrounding
          update_n_lines = '<leader>sn', -- Update `n_lines`
        },
      }
    end,
  }

  use { -- [b ]b etc to manipulate nvim
    'echasnovski/mini.bracketed',
    config = function()
      require('mini.bracketed').setup {}
    end,
  }

  use {
    'ggandor/leap.nvim',
    config = function()
      require('leap').add_default_mappings()
    end,
  }

  use { --easy commenting with gcc
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup {}
    end,
  }

  use { -- add  to function blocks
    'RRethy/nvim-treesitter-endwise',
    config = function()
      require('nvim-treesitter.configs').setup {
        endwise = {
          enable = true,
        },
      }
    end,
  }

  use { -- quickly delete multiple buffers based on the conditions provided
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
  }

  use {
    'windwp/nvim-autopairs',
    config = function()
      require('nvim-autopairs').setup {}
    end,
  }
end
