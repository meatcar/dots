return {
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-omni',
      'FelipeLema/cmp-async-path',
      -- 'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-nvim-lsp-signature-help',
      'kristijanhusak/vim-dadbod-completion',
      'lukas-reineke/cmp-under-comparator',
      'lukas-reineke/cmp-rg',
      'andersevenrud/cmp-tmux', -- Sources words from adjacent tmux panes.
      'onsails/lspkind-nvim',   -- add icons to lsp completions
      { 'saadparwaiz1/cmp_luasnip' },
      { 'doxnit/cmp-luasnip-choice', opts = {} },
    },
    event = me.o.events.insert,
    config = function()
      vim.cmd [[
        autocmd me FileType sql,mysql,plsql lua require('cmp').setup.buffer({ sources = {{ name = 'vim-dadbod-completion' }} })
      ]]

      local cmp = require 'cmp'
      local luasnip = require("luasnip")

      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      ---@diagnostic disable-next-line: missing-fields
      cmp.setup {
        ---@diagnostic disable-next-line: missing-fields
        performance = {
          debounce = 500,
          throttle = 500,
        },
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'nvim_lsp_signature_help' },
          {
            name = 'luasnip',
            entry_filter = function()
              local context = require("cmp.config.context")
              return not context.in_treesitter_capture("string") and not context.in_syntax_group("String")
            end,
          },
          { name = 'luasnip_choice' }
        }, {
          { name = 'async_path' },
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
          ---@diagnostic disable-next-line: missing-fields
          ['<C-x><C-f>'] = cmp.mapping.complete({ config = { sources = { { name = 'async_path' } } } }),
          ---@diagnostic disable-next-line: missing-fields
          ['<C-x><C-s>'] = cmp.mapping.complete({ config = { sources = { { name = 'luasnip' } } } }),
          ---@diagnostic disable-next-line: missing-fields
          ['<C-x><C-t>'] = cmp.mapping.complete({ config = { sources = { { name = 'tmux' } } } }),
          ---@diagnostic disable-next-line: missing-fields
          ['<C-x><C-r>'] = cmp.mapping.complete({ config = { sources = { { name = 'rg' } } } }),
          ['<C-Space>'] = cmp.mapping.confirm { select = true },
          ['<C-g>'] = cmp.mapping.abort(),
          ['<C-d>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ["<Tab>"] = cmp.mapping(function(fallback)
            -- local copilot = require("copilot.suggestion")
            -- if copilot.is_visible() then
            --   copilot.accept()
            -- else
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            elseif has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end, { "i", "s" }),

          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<CR>"] = cmp.mapping({
            i = function(fallback)
              if cmp.visible() and cmp.get_active_entry() then
                cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
              else
                fallback()
              end
            end,
            s = cmp.mapping.confirm({ select = true }),
            c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
          }),
        },
        snippet = {
          expand = function(args) -- REQUIRED - you must specify a snippet engine
            require 'luasnip'.lsp_expand(args.body)
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
          fields = { 'menu', 'abbr', 'kind' },
          format = function(entry, vim_item)
            local cmp_format = require('lspkind').cmp_format {
              mode = 'symbol_text',
              maxwidth = 50,
              menu = {
                path = ' ',
                async_path = ' ',
                rg = '󰍉 ',
                tmux = ' ',
                buffer = '󰧭 ',
                nvim_lsp = '󰘧 ',
                vsnip = '󰢵 ',
                luasnip = '󰢵 ',
                luasnip_choice = '󰢵 ',
                ['vim-dadbod-completion'] = '󱘲 ',
              },
              symbol_map = {
                TypeParameter = ' ',
              },
            }
            local kind = cmp_format(entry, vim_item)
            local menu = kind.menu
            local strings = vim.split(kind.kind, '%s', { trimempty = true })
            if #strings >= 2 then
              kind.kind = ('%s  %s'):format(strings[1], strings[2])
              kind.menu = ('%s'):format(menu)
            end
            return kind
          end,
        },
      }

      ---@diagnostic disable-next-line: missing-fields
      cmp.setup.filetype("DressingInput", {
        sources = cmp.config.sources { { name = "omni" } },
      })
    end,
  },

}
