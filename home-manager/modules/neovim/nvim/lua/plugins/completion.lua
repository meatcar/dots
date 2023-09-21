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
      'onsails/lspkind-nvim',   -- add icons to lsp completions
    },
    event = me.o.events.insert,
    config = function()
      local cmp = require 'cmp'
      vim.cmd [[
        autocmd FileType sql,mysql,plsql lua require('cmp').setup.buffer({ sources = {{ name = 'vim-dadbod-completion' }} })
      ]]

      ---@diagnostic disable-next-line: missing-fields
      cmp.setup {
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          {
            name = 'vsnip',
            entry_filter = function()
              local context = require("cmp.config.context")
              return not context.in_treesitter_capture("string") and not context.in_syntax_group("String")
            end,
          },
        }, {
          { name = 'path' },
        }, {
          { name = 'buffer' },
          { name = 'rg' },
          {
            name = 'tmux',
            option = {
              all_panes = false,
            }
          },
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
          expand = function(args)                -- REQUIRED - you must specify a snippet engine
            vim.fn['vsnip#anonymous'](args.body) -- For `vsnip` users.
          end,
        },
        ---@diagnostic disable-next-line: missing-fields
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
        ---@diagnostic disable-next-line: missing-fields
        view = {
          entries = {
            name = 'custom',
            selection_order = 'near_cursor',
          },
        },
        -- experimental = { ghost_text = false },
        window = {
          ---@diagnostic disable-next-line: missing-fields
          completion = {
            winhighlight = 'Normal:Pmenu,FloatBorder:Pmenu,Search:None',
            col_offset = -1,
            side_padding = 0,
          },
        },
        ---@diagnostic disable-next-line: missing-fields
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
              kind.menu = ('%s(%s)'):format(strings[2], menu)
            end
            return kind
          end,
        },
      }
    end,
  },

}
