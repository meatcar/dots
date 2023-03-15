return {
  {
    'neovim/nvim-lspconfig',
    config = function()
      -- setup default lsp config
      require 'cmp'
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      local lspconfig = require 'lspconfig'
      local util = require 'lspconfig.util'
      util.default_config = vim.tbl_extend('force', util.default_config, {
        capabilities = capabilities,
        on_attach = function(client, bufnr)
          _G.me.fn.illuminate_lsp_on_attach(client, bufnr)
          _G.me.fn.keymap_lsp_on_attach(client, bufnr)
        end,
      })

      lspconfig.lua_ls.setup {
        settings = {
          Lua = {
            runtime = {
              -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
              version = 'LuaJIT',
            },
            diagnostics = { globals = { 'vim' } },
            workspace = {
              -- Make the server aware of Neovim runtime files
              library = vim.api.nvim_get_runtime_file('', true),
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
              enable = false,
            },
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
    end,
  },

  -- TODO update
  --{ -- pretty LSP popups
  --    'glepnir/lspsaga.nvim',
  --    config = function()
  --      require('lspsaga').init_lsp_saga {
  --        error_sign = '',
  --        warn_sign = '',
  --        hint_sign = '',
  --        infor_sign = '',
  --        code_action_keys = {
  --          quit = '<ESC>',
  --          exec = '<CR>',
  --        },
  --      }
  --    end,
  --  },

  'folke/lsp-colors.nvim',

  { -- show all LSP errors
    'folke/trouble.nvim',
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
}
