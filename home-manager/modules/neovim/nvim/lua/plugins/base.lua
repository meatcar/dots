_G.me.o.sidebars = { 'NvimTree', 'qf', 'vista_kind', 'terminal', 'packer', 'Mundo' }

return function(use)
  use 'wbthomason/packer.nvim' -- manage self
  use 'nvim-lua/plenary.nvim' -- used by neovim packages
  use 'tpope/vim-eunuch' -- :Delete, :Move, etc
  use 'tpope/vim-repeat' -- repeat more things
  use 'tpope/vim-unimpaired' -- pairwise mappings like [b, ]b
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

  use { -- work with surrounding text
    'machakann/vim-sandwich',
    config = function()
      -- unmap s, which can easily be replaces by cl
      vim.keymap.set('n', 's', '<Nop>')
      vim.keymap.set('x', 's', '<Nop>')
    end,
  }

  use { --easy commenting with gcc
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup {
        mappings = { extended = true },
      }
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
