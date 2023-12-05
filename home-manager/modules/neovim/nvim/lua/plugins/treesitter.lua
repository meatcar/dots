return {
  { -- nvim-treesitter/nvim-treesitter, installed through nixos
    'nvim-treesitter/nvim-treesitter',
    name = 'nvim-treesitter',
    event = me.o.events.buf_late,
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('nvim-treesitter.configs').setup {
        highlight = { enable = true },
        indent = { enable = true },
      }
      vim.o.foldmethod = 'expr'
      vim.o.foldexpr = 'nvim_treesitter#foldexpr()'
    end,
  },

  -- get the commentstring based on ts context, i.e. vue or jsx files
  {
    'JoosepAlviste/nvim-ts-context-commentstring',
    opts = {
      enable_autocmd = false,
    }
  },
  { -- configure comment.nvim to use the context-sensitive commentstring
    'numToStr/Comment.nvim',
    dependencies = 'JoosepAlviste/nvim-ts-context-commentstring',
    optional = true,
    opts = function(_, opts)
      opts.pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook()
    end
  },

  -- Syntax aware text-objects, select, move, swap, and peek support
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    event = me.o.events.buf_late,
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('nvim-treesitter.configs').setup {
        textobjects = {
          select = {
            enable = true,
            -- Automatically jump forward to textobj, similar to targets.vim
            lookahead = true,

            keymaps = {
              -- You can use the capture groups defined in textobjects.scm
              ['af'] = '@function.outer',
              ['if'] = '@function.inner',
              ['ac'] = '@class.outer',
              ['ic'] = '@class.inner',
              ['aa'] = '@parameter.outer',
              ['ia'] = '@parameter.inner',
              ['ak'] = '@block.outer',
              ['ik'] = '@block.inner',
            },
            -- You can choose the select mode (default is charwise 'v')
            selection_modes = {
              ['@parameter.outer'] = 'v', -- charwise
              ['@function.outer'] = 'V',  -- linewise
              ['@class.outer'] = '<c-v>', -- blockwise
            },
          },
          swap = {
            enable = true,
            swap_next = {
              ['<leader>a'] = '@parameter.inner',
            },
            swap_previous = {
              ['<leader>A'] = '@parameter.inner',
            },
          },
          lsp_interop = {
            enable = true,
            border = 'none',
            peek_definition_code = {
              ['<leader>df'] = '@function.outer',
              ['<leader>dF'] = '@class.outer',
            },
          },
        },
      }
    end,
  },
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
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    event = me.o.events.buf_late,
    keys = {
      { "<leader>tT", ":TSContextToggle<CR>", desc = 'Top TS context' }
    },
    opts = {}
  }
}
