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
    init = function()
      vim.g.user_emmet_leader_key = '<localleader>'
      vim.g.user_emmet_install_global = false
      -- insert-mode only, keeps normal-mode <localleader>j for treesj
      vim.g.user_emmet_mode = 'i'
    end,
    config = function()
      -- lazy's ft trigger fires after FileType, so install for the current
      -- buffer directly and future buffers via autocmd
      vim.cmd [[EmmetInstall]]
      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'html', 'handlebars', 'css', 'less', 'sass', 'scss', 'jsx' },
        group = vim.api.nvim_create_augroup('me.emmet', {}),
        command = 'EmmetInstall',
      })
    end,
  },

  {
    'jceb/vim-orgmode',
    ft = '*.org',
    dependencies = { 'inkarkat/vim-SyntaxRange', ft = 'org' },
  },

  -- Markdown
  { -- make editing freetext easier
    'reedes/vim-pencil',
    ft = { 'markdown', 'text', 'mail' },
    config = function()
      vim.g.pencil_gutter_color = true
    end,
  },
  { -- preview markdown
    'ellisonleao/glow.nvim',
    cmd = 'Glow',
    opts = {},
    keys = {
      { '<localleader>p', '<Cmd>Glow<CR>', ft = 'markdown', desc = 'Glow preview' },
    },
  },
  {
    "OXY2DEV/markview.nvim",
    lazy = false,
    -- markview manages conceallevel/concealcursor itself; hybrid + linewise
    -- shows the cursor line (±1) as raw text in n/i modes so edits line up
    -- with actual characters.
    opts = {
      markdown_inline = {
        checkboxes = {
          enable = true,

          checked = { text = "󰗠 ", hl = "MarkviewCheckboxChecked", scope_hl = "MarkviewCheckboxStriked" },
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
          -- follow the buffer's indent like the indent_size default does,
          -- instead of the hardcoded 4-space render shift
          shift_width = function(buffer)
            if type(buffer) ~= "number" then
              return vim.bo.shiftwidth or 4
            end
            return vim.bo[buffer].shiftwidth or 4
          end,
        }
      },
      preview = {
        modes = { "i", "n", "no", "c" },
        hybrid_modes = { "i", "n" },
        linewise_hybrid_mode = true,
        edit_range = { 1, 1 },
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
      { "<localleader>mm", "<cmd>Markview toggle<cr>",       desc = "Toggle preview" },
      { "<localleader>mM", "<cmd>Markview Toggle<cr>",       desc = "Toggle preview (all)" },
      { "<localleader>mh", "<cmd>Markview hybridToggle<cr>", desc = "Toggle hybrid mode" },
      { "<localleader>ms", "<cmd>Markview splitToggle<cr>",  desc = "Toggle split preview" },
      { "<localleader>cc", "<cmd>Checkbox change 1 0<cr>",   desc = "Cycle checkbox state" },
      { "<localleader>cn", "<cmd>Checkbox change 0 1<cr>",   desc = "Next checkbox set" },
      { "<localleader>cp", "<cmd>Checkbox change 0 -1<cr>",  desc = "Prev checkbox set" },
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
  {
    'calops/hmts.nvim',
    ft = 'nix',
    version = '*',
    init = function()
      -- Neovim 0.12 passes predicate/directive handlers `match` as a list of
      -- nodes per capture (nil when absent); hmts v1.3.0 assumes a single node.
      -- Wrap registration to normalize match to single nodes (old `all=false`
      -- behavior) only for hmts's own handlers; restore the API in `config`.
      local query = vim.treesitter.query
      local orig_predicate = query.add_predicate
      local orig_directive = query.add_directive

      local function normalize(match)
        local fixed = {}
        for k, v in pairs(match) do
          fixed[k] = (type(v) == 'table' and v[#v]) or v
        end
        return fixed
      end

      vim.g._hmts_restore = function()
        query.add_predicate = orig_predicate
        query.add_directive = orig_directive
      end

      query.add_predicate = function(name, handler, opts)
        if name == 'hmts-path?' then
          local function wrapped(match, pattern, source, predicate, metadata)
            local m = normalize(match)
            if m[predicate[2]] == nil then
              return false
            end
            return handler(m, pattern, source, predicate, metadata)
          end
          return orig_predicate(name, wrapped, opts)
        end
        return orig_predicate(name, handler, opts)
      end

      query.add_directive = function(name, handler, opts)
        if name == 'hmts-inject!' then
          local function wrapped(match, pattern, source, predicate, metadata)
            local m = normalize(match)
            if m[predicate[2]] == nil then
              return
            end
            return handler(m, pattern, source, predicate, metadata)
          end
          return orig_directive(name, wrapped, opts)
        end
        return orig_directive(name, handler, opts)
      end
    end,
    config = function()
      if vim.g._hmts_restore then
        vim.g._hmts_restore()
      end
    end,
  },
}
