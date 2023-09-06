local keymaps = require 'core/keymaps'

local signs = { Error = '󰅚', Warn = '', Hint = '󰌶', Info = '󰋽' }
for type, icon in pairs(signs) do
  local hl = ('DiagnosticSign%s'):format(type)
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

return {
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      { "b0o/schemastore.nvim", lazy = true },
      { "folke/neoconf.nvim",   config = true, cmd = 'Neoconf' },
      { "folke/neodev.nvim",    config = true, lazy = true },
    },
    config = function()
      require 'neodev'
      require 'cmp'
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local cmp_capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

      local augroup = vim.api.nvim_create_augroup('LspFormat', { clear = true })

      local lspconfig = require 'lspconfig'
      local util = require 'lspconfig.util'
      util.default_config = vim.tbl_extend('force', util.default_config, {
        capabilities = cmp_capabilities,
        on_attach = function(client, bufnr)
          require('illuminate').on_attach(client)
          keymaps.lsp_on_attach(client, bufnr)

          -- format on save
          if client.supports_method 'textDocument/formatting' then
            vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
            vim.api.nvim_create_autocmd('BufWritePre', {
              group = augroup,
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.format { bufnr = bufnr, async = false }
              end,
            })
          end
        end,
      })

      lspconfig.lua_ls.setup {
        settings = {
          Lua = {
            -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
            runtime = { version = 'LuaJIT' },
            workspace = {
              checkThirdParty = false, -- disable unhelpful prompts
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = { enable = false },
          },
        },
      }
      lspconfig.rnix.setup {}
      lspconfig.terraformls.setup {}
      lspconfig.gopls.setup {}
      lspconfig.ansiblels.setup {}
      lspconfig.elixirls.setup {}
      lspconfig.eslint.setup {}
      lspconfig.cssls.setup {}
      lspconfig.html.setup {}
      lspconfig.tsserver.setup {}
      lspconfig.bashls.setup {}
      lspconfig.dockerls.setup {}
      lspconfig.jsonls.setup {
        settings = {
          json = {
            schemas = require('schemastore').json.schemas(),
            validate = { enable = true },
          },
        },
      }
      lspconfig.yamlls.setup {
        settings = {
          yaml = {
            schemas = require('schemastore').yaml.schemas(),
            schemaStore = { enable = false, url = "" }, -- disable built-in schemaStore support
          },
        },
      }
    end,
  },

  {
    -- async error checking
    'jose-elias-alvarez/null-ls.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local null_ls = require 'null-ls'

      null_ls.setup {
        sources = {
          null_ls.builtins.diagnostics.clj_kondo,

          null_ls.builtins.completion.spell,

          -- null_ls.builtins.formatting.stylua,
          null_ls.builtins.formatting.eslint_d,
          null_ls.builtins.formatting.prettier,
          null_ls.builtins.formatting.stylelint,
          null_ls.builtins.formatting.autopep8,
          null_ls.builtins.formatting.nixpkgs_fmt,
          null_ls.builtins.formatting.shfmt,
          null_ls.builtins.formatting.gofmt,
          null_ls.builtins.formatting.joker,
        },
      }
    end,
  },

  {
    -- pretty LSP popups

    'nvimdev/lspsaga.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
      code_action = {
        keys = {
          quit = '<ESC>',
          exec = '<CR>',
        },
      },
      symbol_in_winbar = {
        enable = false,
        color_mode = false,
        separator = '  ',
      },
      lightbulb = {
        virtual_text = false
      }
    },
  },

  { 'Bekaboo/dropbar.nvim', event = { 'BufReadPre', 'BufNewFile' } },

  'folke/lsp-colors.nvim',

  {
    -- show all LSP errors
    'folke/trouble.nvim',
    keys = {
      { '<leader>ol', '<Cmd>TroubleToggle<CR>',                desc = 'LSP List' },
      { '<leader>lr', '<Cmd>TroubleToggle lsp_references<CR>', desc = 'References' },
    },
    opts = {
      use_lsp_diagnostic_signs = false,
    },
  },

  {
    'https://git.sr.ht/~whynothugo/lsp_lines.nvim',
    config = function()
      require('lsp_lines').setup()
      vim.diagnostic.config {
        virtual_lines = false,
        virtual_text = true,
        update_in_insert = true,
      }
    end,
  },

  {
    'cshuaimin/ssr.nvim',
    keys = {
      {
        '<leader>sr',
        function()
          require('ssr').open()
        end,
        desc = 'Structural Search/Replace',
        mode = { 'n', 'x' },
      },
    },
    opts = {
      min_width = 50,
      min_height = 5,
      keymaps = {
        close = 'q',
        next_match = 'n',
        prev_match = 'N',
        replace_all = '<leader><cr>',
      },
    },
  },

  {
    'j-hui/fidget.nvim',
    event = 'VeryLazy',
    tag = 'legacy',
    opts = {
      text = {
        spinner = 'dots',
      },
    },
  },

  {
    'ray-x/lsp_signature.nvim',
    event = 'BufReadPre',
    config = true
  },

  { -- defer diagnostics until insert mode is exited
    'yorickpeterse/nvim-dd',
    event = { 'BufReadPre', 'BufNewFile' },
    config = true
  }
}
