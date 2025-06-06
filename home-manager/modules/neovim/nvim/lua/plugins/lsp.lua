local keymaps = require 'core/keymaps'

local signs = { Error = '󰅚', Warn = '', Hint = '󰌶', Info = '󰋽' }
for type, icon in pairs(signs) do
  local hl = ('DiagnosticSign%s'):format(type)
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

return {
  {
    'neovim/nvim-lspconfig',
    version = "*",
    event = me.o.events.buf_early,
    dependencies = {
      { "b0o/schemastore.nvim" },
      { "folke/neoconf.nvim",  opts = {}, cmd = 'Neoconf' },
      { "folke/neodev.nvim",   opts = {} },
      { "sigmaSd/deno-nvim" }, -- no opts, as we require it down below
    },
    keys = {
      { '<leader>llr', '<Cmd>LspRestart<CR>', desc = 'Restart' },
      { '<leader>llo', '<Cmd>LspStop<CR>',    desc = 'Stop' },
      { '<leader>lla', '<Cmd>LspStart<CR>',   desc = 'Start' },
      { '<leader>lll', '<Cmd>LspInfo<CR>',    desc = 'Info' },
    },
    init = function()
      require('which-key').add({ '<leader>ll', group = 'lspconfig' })
    end,
    config = function()
      require 'neodev'
      require 'cmp'
      local lspconfig = require 'lspconfig'
      local servers = {
        lua_ls = {
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
        },
        nil_ls = {
          formatting = {
            command = 'nixfmt',
          }
        },
        terraformls = {},
        gopls = {},
        ansiblels = {},
        elixirls = {},
        eslint = {},
        cssls = {
          handlers = {
            ["textDocument/diagnostic"] = function() end
          }
        },
        html = {},
        bashls = {},
        dockerls = {},
        zls = {},
        ts_ls = {
          root_dir = lspconfig.util.root_pattern("package.json"),
          single_file_support = false
        },
        jsonls = {
          settings = {
            json = {
              schemas = require('schemastore').json.schemas(),
              validate = { enable = true },
            },
          },
          handlers = {
            ["textDocument/diagnostic"] = function() end
          }
        },
        yamlls = {
          settings = {
            yaml = {
              schemas = require('schemastore').yaml.schemas(),
              schemaStore = { enable = false, url = "" }, -- disable built-in schemaStore support
            },
          },
        }
      }

      local default_capabilities = vim.lsp.protocol.make_client_capabilities()
      local capabilities = vim.tbl_deep_extend('force', default_capabilities,
        require('blink.cmp').get_lsp_capabilities({}, false))
      local on_attach = keymaps.lsp_on_attach

      for server, config in pairs(servers) do
        config.capabilities = require('blink.cmp').get_lsp_capabilities(config.capabilities)
        config.on_attach = on_attach
        lspconfig[server].setup(config)
      end

      require("deno-nvim").setup {
        server = {
          root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc"),
          capabilities = capabilities,
          on_attach = on_attach,
        }
      }
    end,
  },

  {
    -- pretty LSP popups

    'nvimdev/lspsaga.nvim',
    event = me.o.events.buf_early,
    keys = {
      { '<leader>la', '<Cmd>Lspsaga code_action<CR>',             desc = 'Action' },
      { '<leader>lh', '<Cmd>Lspsaga hover_doc<CR>',               desc = 'Hover Doc' },
      { '<leader>ls', '<Cmd>Lspsaga signature_help<CR>',          desc = 'Signature' },
      { '<leader>lm', '<Cmd>Lspsaga rename<CR>',                  desc = 'Rename' },
      { '<leader>ld', '<Cmd>Lspsaga peek_definition<CR>',         desc = 'Definition' },
      { '<leader>li', '<Cmd>Lspsaga show_line_diagnostics<CR>',   desc = 'Line info' },
      { '<leader>lc', '<Cmd>Lspsaga show_cursor_diagnostics<CR>', desc = 'Cursor info' },
      { '<leader>la', '<Cmd>Lspsaga range_code_action<CR>',       desc = 'Action',     mode = 'v' },
    },
    opts = function()
      return {
        ui = {
          kind = require("catppuccin.groups.integrations.lsp_saga").custom_kind()
        },
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
          virtual_text = true,
          sign = false
        }
      }
    end,
  },

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
    event = me.o.events.buf_early,
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
    event = me.o.events.verylazy,
    tag = 'legacy',
    opts = {
      text = { spinner = 'dots' },
      window = { blend = 0 }
    },
  },

  {
    'ray-x/lsp_signature.nvim',
    event = me.o.events.buf_early,
    opts = {}
  },

  -- { -- defer diagnostics until insert mode is exited
  --   'yorickpeterse/nvim-dd',
  --   event = me.o.events.buf_early,
  --   opts = {}
  -- }
}
