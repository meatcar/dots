return function(use)
  use {
    'hrsh7th/nvim-cmp',
    requires = {
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
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<CR>'] = cmp.mapping.confirm { select = true },
          ['<C-e>'] = cmp.mapping.abort(),
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
            }
            local kind = cmp_format(entry, vim_item)
            local menu = kind.menu
            local strings = vim.split(kind.kind, '%s', { trimempty = true })
            kind.kind = strings[1]
            kind.menu = strings[2] .. ' (' .. menu .. ')'
            return kind
          end,
        },
      }
    end,
  }

  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup {
        ensure_installed = 'all',
        ignore_install = { 'swift' },
        highlight = { enable = true },
        indent = { enable = true },
      }
      vim.o.foldmethod = 'expr'
      vim.o.foldexpr = 'nvim_treesitter#foldexpr()'
    end,
  }

  use {
    'kkoomen/vim-doge',
    run = ':call doge#install()',
    config = function()
      vim.g.doge_javascript_settings = {
        destructuring_props = true,
        omit_redundant_param_types = true,
      }
    end,
  }
end