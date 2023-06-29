local keymaps = require 'core/keymaps'

local signs = { Error = '', Warn = '', Hint = '', Info = '' }
for type, icon in pairs(signs) do
  local hl = 'DiagnosticSign' .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

return {
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
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

  {
    -- async error checking
    'jose-elias-alvarez/null-ls.nvim',
    config = function()
      local null_ls = require 'null-ls'

      null_ls.setup {
        sources = {
          null_ls.builtins.diagnostics.clj_kondo,

          null_ls.builtins.completion.spell,

          null_ls.builtins.formatting.stylua,
          null_ls.builtins.formatting.eslint_d,
          null_ls.builtins.formatting.prettier,
          null_ls.builtins.formatting.stylelint,
          null_ls.builtins.formatting.autopep8,
          null_ls.builtins.formatting.nixpkgs_fmt,
          null_ls.builtins.formatting.shfmt,
          null_ls.builtins.formatting.gofmt,
          null_ls.builtins.formatting.joker,
        },
        -- format on save
        on_attach = function(client, bufnr)
          if client.supports_method 'textDocument/formatting' then
            vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
            vim.api.nvim_create_autocmd('BufWritePre', {
              group = augroup,
              buffer = bufnr,
              callback = function()
                -- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
                vim.lsp.buf.format { bufnr = bufnr }
              end,
            })
          end
        end,
      }
    end,
  },

  {
    -- pretty LSP popups

    'glepnir/lspsaga.nvim',
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

  {
    -- show all LSP errors
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
    opts = {
      text = {
        spinner = 'dots',
      },
    },
  },
}
