return {
  -- { -- A plethora of syntaxes
  --   'sheerun/vim-polyglot',
  --   event = me.o.events.buf_early,
  --   init = function()
  --     vim.g.polyglot_disabled = { 'ftdetect', 'yaml', 'markdown', 'scala' }
  --   end,
  -- },

  { 'zirrostig/vim-shbed',       ft = { 'sh', 'fish' } },
  {
    'lervag/vimtex',
    ft = { 'tex', 'latex' },
    init = function() end,
  },
  { 'neomutt/neomutt.vim',       ft = 'mail' },
  { 'pantharshit00/vim-prisma',  ft = 'prisma' },
  { 'nathangrigg/vim-beancount', ft = { '*.bean', '*.beancount' } },

  {
    'mattn/emmet-vim',
    ft = { 'html', 'handlebars', 'css', 'less', 'sass', 'scss', 'jsx' },
    config = function()
      vim.g.user_emmet_leader_key = '<localleader>'
      vim.g.user_emmet_install_global = false
      vim.cmd [[EmmetInstall]]
    end,
  },

  {
    'jceb/vim-orgmode',
    ft = '*.org',
    dependencies = { 'inkarkat/vim-SyntaxRange', ft = 'org' },
  },

  -- Markdown
  -- {
  --   'tpope/vim-markdown',
  --   ft = { '*.md', '*.markdown' },
  --   config = function()
  --     vim.g.vim_markdown_fenced_languages = {
  --       'javascript',
  --       'js=javascript',
  --       'json=javascript',
  --       'java',
  --       'css',
  --       'sass',
  --       'mustache',
  --       'html=mustache',
  --       'sh',
  --       'shell=sh',
  --     }
  --   end,
  -- },
  -- { -- Fancy markdown extras
  --   'SidOfc/mkdx',
  --   ft = { 'md', 'markdown' },
  --   config = function()
  --     vim.g['mkdx#settings'] = {
  --       map = { prefix = '<localleader>', enable = 1 },
  --       tokens = {
  --         enter = { '-', '*', '>' },
  --         bold = '**',
  --         italic = '*',
  --         strike = '',
  --         list = '-',
  --         fence = '',
  --         header = '#',
  --       },
  --       checkbox = {
  --         toggles = { ' ', '-', 'x' },
  --         update_tree = 2,
  --         initial_state = ' ',
  --       },
  --       highlight = { enable = 1 },
  --       auto_update = { enable = 1 },
  --       fold = { enable = 1 },
  --     }
  --   end,
  -- },
  { -- make editing freetext easier
    'reedes/vim-pencil',
    ft = { 'markdown', 'text', 'mail' },
    config = function()
      vim.g.pencil_gutter_color = true
    end,
  },
  { -- preview markdown
    'npxbr/glow.nvim',
    ft = { 'markdown' },
    cmd = 'Glow',
    config = function()
      vim.keymap.set('n', '<localleader>p', [[<Cmd>Glow<CR>]], { buffer = 0 })
    end,
  },
  {
    "OXY2DEV/markview.nvim",
    lazy = false,
    opts = {
      markdown_inline = {
        checkboxes = {
          enable = true,

          checked = { text = "󰗠 ", hl = "MarkviewCheckboxChecked", scope_hl = "MarkviewCheckboxStriked"},
          unchecked = { text = "󰄰 ", hl = "MarkviewCheckboxUnchecked", scope_hl = "none" },

          ["-"] = { text = "󱎖 ", hl = "MarkviewCheckboxPending", scope_hl = "none" },
          [">"] = { text = " ", hl = "MarkviewCheckboxCancelled" },
          ["<"] = { text = "󰃖 ", hl = "MarkviewCheckboxCancelled" },
          ["/"] = { text = "󰍶 ", hl = "MarkviewCheckboxCancelled", scope_hl = "MarkviewCheckboxStriked" },

          ["?"] = { text = "󰋗 ", hl = "MarkviewCheckboxPending" },
          ["!"] = { text = "󰀦 ", hl = "MarkviewCheckboxUnchecked" },
          ["*"] = { text = "󰓎 ", hl = "MarkviewCheckboxPending" },
          ['"'] = { text = "󰸥 ", hl = "MarkviewCheckboxCancelled" },
          ["l"] = { text = "󰆋 ", hl = "MarkviewCheckboxProgress" },
          ["b"] = { text = "󰃀 ", hl = "MarkviewCheckboxProgress" },
          ["i"] = { text = "󰰄 ", hl = "MarkviewCheckboxChecked" },
          ["$"] = { text = " ", hl = "MarkviewCheckboxChecked" },
          ["I"] = { text = "󰛨 ", hl = "MarkviewCheckboxPending" },
          ["y"] = { text = " ", hl = "MarkviewCheckboxChecked" },
          ["n"] = { text = " ", hl = "MarkviewCheckboxUnchecked" },
          ["f"] = { text = "󱠇 ", hl = "MarkviewCheckboxUnchecked" },
          ["k"] = { text = " ", hl = "MarkviewCheckboxPending" },
          ["w"] = { text = " ", hl = "MarkviewCheckboxProgress" },
          ["u"] = { text = "󰔵 ", hl = "MarkviewCheckboxChecked" },
          ["d"] = { text = "󰔳 ", hl = "MarkviewCheckboxUnchecked" },
        }
      },
      markdown = {
        list_items = {
          enable = true
        }
      },
      preview = {
        modes = { "i", "n", "no", "c" },
        hybrid_modes = { "i" },
                linewise_hybrid_mode = true,
        edit_range = {1,1},

        callbacks = {
          on_enable = function(_, win)
            vim.wo[win].conceallevel = 3;
            vim.wo[win].concealcursor = "nc";
          end
        }
      }
    },
    config = function(_, opts)
      require("markview").setup(opts)
      require("markview.extras.checkboxes").setup({
        default = " ",
        remove_style = "checkbox",
        states = {
          { " ", "-", "x" },
          { "/", "<", ">" },
          { "!", "?", "*" },
          { "y", "n" }
        }
      })
    end,
    keys = {
      { "<localleader>tt", "<cmd>Checkbox change 1 0<cr>", desc = "Toggle checkbox" },
      { "<localleader>tn", "<cmd>Checkbox change 0 1<cr>", desc = "Toggle checkbox" },
      { "<localleader>tp", "<cmd>Checkbox change 0 -1<cr>", desc = "Toggle checkbox" },
    }
  },



  -- clojure
  { 'tpope/vim-classpath',    ft = 'clojure' },
  { -- static support for Leiningen
    'tpope/vim-salve',
    ft = 'clojure',
    dependencies = { 'tpope/vim-projectionist', ft = 'clojure' }, -- quick-switch between src and test
  },
  { 'eraserhd/parinfer-rust', ft = 'clojure' },
  { 'liquidz/vim-iced',       ft = 'clojure' },

  -- lua
  { 'milisims/nvim-luaref' },

  -- nix
  { "calops/hmts.nvim",       ft = "nix",    version = "*" },
}
