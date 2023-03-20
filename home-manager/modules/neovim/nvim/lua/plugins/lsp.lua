local keymaps = require 'core/keymaps'

return {
  {
    'neovim/nvim-lspconfig',
    event = 'VeryLazy',
    config = function()
      -- setup default lsp config
      require 'cmp'
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      local lspconfig = require 'lspconfig'
      local util = require 'lspconfig.util'
      util.default_config = vim.tbl_extend('force', util.default_config, {
        capabilities = capabilities,
        on_attach = function(client, bufnr)
          require('illuminate').on_attach(client)
          keymaps.lsp_on_attach(client, bufnr)
        end,
      })

      lspconfig.lua_ls.setup {
        settings = {
          Lua = {
            -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
            runtime = { version = 'LuaJIT' },
            -- don't warn for some undefined globals
            diagnostics = { globals = { 'vim' } },
            workspace = {
              -- Make the server aware of Neovim runtime files
              library = vim.api.nvim_get_runtime_file('', true),
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
    end,
  },

  { -- pretty LSP popups

    'glepnir/lspsaga.nvim',
    dependencies = {
      { 'nvim-tree/nvim-web-devicons' },
      --Please make sure you install markdown and markdown_inline parser
      { 'nvim-treesitter/nvim-treesitter' },
    },
    event = 'BufRead',
    opts = {
      code_action = {
        keys = {
          quit = '<ESC>',
          exec = '<CR>',
        },
      },
    },
  },

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

  {
    'j-hui/fidget.nvim',
    opts = {
      text = {
        spinner = 'dots',
      },
    },
  },
}
