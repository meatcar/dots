return function(use)
  use { -- easily install new lsp servers
    'williamboman/nvim-lsp-installer',
    requires = 'neovim/nvim-lspconfig',
    config = function()
      local lspinstaller = require 'nvim-lsp-installer'
      lspinstaller.setup {}

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

      -- setup individual lsp servers
      for _, server in ipairs(lspinstaller.get_installed_servers()) do
        if server.name == 'sumneko_lua' then
          lspconfig.sumneko_lua.setup {
            settings = { Lua = { diagnostics = { globals = { 'vim' } } } },
          }
        else
          lspconfig[server.name].setup {}
        end
      end
    end,
  }

  use { -- pretty LSP popups
    'tami5/lspsaga.nvim',
    config = function()
      require('lspsaga').init_lsp_saga {
        error_sign = '',
        warn_sign = '',
        hint_sign = '',
        infor_sign = '',
        code_action_keys = {
          quit = '<ESC>',
          exec = '<CR>',
        },
      }
    end,
  }

  use 'folke/lsp-colors.nvim'

  use { -- show all LSP errors
    'folke/lsp-trouble.nvim',
    config = function()
      require('trouble').setup {
        use_lsp_diagnostic_signs = false,
      }
    end,
  }

  use {
    'https://git.sr.ht/~whynothugo/lsp_lines.nvim',
    config = function()
      require('lsp_lines').setup()
      vim.diagnostic.config {
        virtual_lines = false,
        virtual_text = true,
        update_in_insert = true,
      }
    end,
  }
end
