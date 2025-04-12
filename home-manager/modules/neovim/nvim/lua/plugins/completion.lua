-- TODO: delete. Keeping for reference.
-- {
--   'hrsh7th/nvim-cmp',
--   dependencies = {
--     'hrsh7th/cmp-nvim-lsp',
--     'hrsh7th/cmp-buffer',
--     'hrsh7th/cmp-omni',
--     'FelipeLema/cmp-async-path',
--     -- 'hrsh7th/cmp-cmdline',
--     'hrsh7th/cmp-nvim-lsp-signature-help',
--     'kristijanhusak/vim-dadbod-completion',
--     'lukas-reineke/cmp-under-comparator',
--     'lukas-reineke/cmp-rg',
--     'andersevenrud/cmp-tmux', -- Sources words from adjacent tmux panes.
--     'onsails/lspkind-nvim',   -- add icons to lsp completions
--     { 'saadparwaiz1/cmp_luasnip' },
--     { 'doxnit/cmp-luasnip-choice', opts = {} },
--   },

return {
  {
    'saghen/blink.cmp',
    -- optional: provides snippets for the snippet source
    dependencies = {
      'rafamadriz/friendly-snippets',
      'mgalliou/blink-cmp-tmux',
      'disrupted/blink-cmp-conventional-commits',
    },

    event = me.o.events.insert,
    -- use a release tag to download pre-built binaries
    version = '1.*',
    -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
    -- build = 'cargo build --release',
    -- If you use nix, you can build from source using latest nightly rust with:
    -- build = 'nix run .#build-plugin',

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
      -- 'super-tab' for mappings similar to vscode (tab to accept)
      -- 'enter' for enter to accept
      -- 'none' for no mappings
      --
      -- All presets have the following mappings:
      -- C-space: Open menu or open docs if already open
      -- C-n/C-p or Up/Down: Select next/previous item
      -- C-e: Hide menu
      -- C-k: Toggle signature help (if signature.enabled = true)
      --
      appearance = {
        -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = 'mono'
      },

      completion = {
        -- (Default) Only show the documentation popup when manually triggered
        documentation = { auto_show = true, auto_show_delay_ms = 250 },
        -- autopair completion
        accept = { auto_brackets = { enabled = true } }
      },

      -- Default list of enabled providers defined so that you can extend it
      -- elsewhere in your config, without redefining it, due to `opts_extend`
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer', 'tmux' },
        providers = {
          tmux = {
            module = 'blink-cmp-tmux',
            name = 'tmux',
            opts = {
              all_panes = true
            }
          },
          conventional_commits = {
            name = 'Conventional Commits',
            module = 'blink-cmp-conventional-commits',
            enabled = function()
              return vim.bo.filetype == 'gitcommit'
            end,
            ---@module 'blink-cmp-conventional-commits'
            ---@type blink-cmp-conventional-commits.Options
            opts = {}, -- none so far
          },
        },
        per_filetype = {
          codecompanion = { "codecompanion" },
        }
      },

      -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
      -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
      -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
      --
      -- See the fuzzy documentation for more information
      fuzzy = { implementation = "prefer_rust_with_warning" },

      -- See :h blink-cmp-config-keymap for defining your own keymap
      keymap = {
        preset = 'enter',
        ['<Tab>'] = {
          function(cmp)
            local copilot = require("copilot.suggestion")
            if copilot.is_visible() then
              copilot.accept()
              return true
            end
          end,
          'select_next'
        }
      }
    },
    opts_extend = { "sources.default" }
  },
}
