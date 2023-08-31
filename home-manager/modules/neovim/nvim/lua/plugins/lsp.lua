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
      "folke/neodev.nvim",
      opts = {
        override = function(root_dir, library)
          if root_dir:find(table.concat({ vim.fn.expand("$HOME"), "/git/hub/meatcar/dots" }), 1, true) == 1 then
            library.enabled = true
            library.plugins = true
            library.runtime = true
            library.types = true
          end
        end,
      },
      config = true
    },
    config = function()
      -- setup default lsp config
      require 'cmp'
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      local augroup = vim.api.nvim_create_augroup('LspFormat', { clear = true })

      local lspconfig = require 'lspconfig'
      local util = require 'lspconfig.util'
      util.default_config = vim.tbl_extend('force', util.default_config, {
        capabilities = capabilities,
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
            -- don't warn for some undefined globals
            diagnostics = { globals = { 'vim' } },
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
