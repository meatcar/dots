return {
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      -- 'hrsh7th/cmp-cmdline',
      'hrsh7th/nvim-cmp',
      'hrsh7th/cmp-vsnip',
      'kristijanhusak/vim-dadbod-completion',
      'lukas-reineke/cmp-under-comparator',
      'lukas-reineke/cmp-rg',
      'andersevenrud/cmp-tmux', -- Sources words from adjacent tmux panes.
      'onsails/lspkind-nvim', -- add icons to lsp completions
    },
    event = 'InsertEnter',
    config = function()
      local cmp = require 'cmp'
      vim.cmd [[
        autocmd FileType sql,mysql,plsql lua require('cmp').setup.buffer({ sources = {{ name = 'vim-dadbod-completion' }} })
      ]]

      cmp.setup {
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'vsnip' },
        }, {
          { name = 'path' },
        }, {
          { name = 'buffer' },
          { name = 'rg' },
          { name = 'tmux', option = {
            all_panes = false,
          } },
        }),
        mapping = cmp.mapping.preset.insert {
          ['<C-x><C-o>'] = cmp.mapping.complete(),
          ['<CR>'] = cmp.mapping.confirm(),
          ['<C-Space>'] = cmp.mapping.confirm { select = true },
          ['<C-g>'] = cmp.mapping.abort(),
          ['<C-d>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
        },
        snippet = {
          expand = function(args) -- REQUIRED - you must specify a snippet engine
            vim.fn['vsnip#anonymous'](args.body) -- For `vsnip` users.
          end,
        },
        sorting = {
          comparators = {
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.score,
            require('cmp-under-comparator').under,
            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
          },
        },
        view = {
          entries = {
            name = 'custom',
            selection_order = 'near_cursor',
          },
        },
        -- experimental = { ghost_text = false },
        window = {
          completion = {
            winhighlight = 'Normal:Pmenu,FloatBorder:Pmenu,Search:None',
            col_offset = -1,
            side_padding = 0,
          },
        },
        formatting = {
          fields = { 'kind', 'abbr', 'menu' },
          format = function(entry, vim_item)
            local cmp_format = require('lspkind').cmp_format {
              mode = 'symbol_text',
              maxwidth = 50,
              menu = {
                path = 'pth',
                rg = 'rg',
                tmux = 'tmux',
                buffer = 'buf',
                nvim_lsp = 'lsp',
                vsnip = 'snip',
                ['vim-dadbod-completion'] = 'db',
              },
              symbol_map = {
                TypeParameter = '',
              },
            }
            local kind = cmp_format(entry, vim_item)
            local menu = kind.menu
            local strings = vim.split(kind.kind, '%s', { trimempty = true })
            if #strings >= 2 then
              kind.kind = strings[1]
              kind.menu = strings[2] .. ' (' .. menu .. ')'
            end
            return kind
          end,
        },
      }
    end,
  },

  {
    'nvim-treesitter/nvim-treesitter',
    event = { 'BufReadPost', 'BufNewFile' },
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup {
        ensure_installed = 'all',
        ignore_install = { 'swift' },
        highlight = { enable = true },
        indent = { enable = true },
      }
      vim.o.foldmethod = 'expr'
      vim.o.foldexpr = 'nvim_treesitter#foldexpr()'
      vim.o.foldlevelstart = 3
    end,
  },

  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    event = { 'BufReadPost', 'BufNewFile' },
    config = function()
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
              ['@function.outer'] = 'V', -- linewise
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

  {
    'kkoomen/vim-doge',
    build = ':call doge#install()',
    config = function()
      vim.g.doge_javascript_settings = {
        destructuring_props = true,
        omit_redundant_param_types = true,
      }
    end,
  },
}
