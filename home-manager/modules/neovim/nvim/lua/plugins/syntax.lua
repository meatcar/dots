return {
  { -- A plethora of syntaxes
    'sheerun/vim-polyglot',
    event = me.o.events.buf_early,
    init = function()
      vim.g.polyglot_disabled = { 'yaml', 'markdown', 'scala' }
    end,
  },

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
  {
    'tpope/vim-markdown',
    ft = { '*.md', '*.markdown' },
    config = function()
      vim.g.vim_markdown_fenced_languages = {
        'javascript',
        'js=javascript',
        'json=javascript',
        'java',
        'css',
        'sass',
        'mustache',
        'html=mustache',
        'sh',
        'shell=sh',
      }
    end,
  },
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
    ft = { 'md', 'markdown', 'text', 'mail' },
    config = function()
      vim.g.pencil_gutter_color = true
    end,
  },
  { -- preview markdown
    'npxbr/glow.nvim',
    ft = { 'md', 'markdown' },
    cmd = 'Glow',
    config = function()
      vim.keymap.set('n', '<localleader>p', [[<Cmd>Glow<CR>]], { buffer = 0 })
    end,
  },
  { -- highlight headlines and codeblocks in markdown
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
    ft = { 'md', 'markdown' },
    opts = {
      completions = { blink = { enabled = true } },
      bullet = {
        enabled = false
      },
      checkbox = {
        bullet = true,
        right_pad = 1,
        unchecked = { icon = '  ' },
        checked = { icon = '  ', scope_highlight = '@markup.strikethrough' },
        custom = {
          todo = { raw = '[-]', rendered = '  ', highlight = 'RenderMarkdownTodo', scope_highlight = nil },
          arrow = { raw = '[>]', rendered = '  ', highlight = 'RenderMarkdownTodo', scope_highlight = nil },
          tilde = { raw = '[~]', rendered = '  ', highlight = 'RenderMarkdownTodo', scope_highlight = '@markup.strikethrough' },
          important = { raw = '[!]', rendered = '  ', highlight = 'RenderMarkdownTodo', scope_highlight = nil },
        }
      },
      heading = {
        icons = {
          '󰎦 ', '󰎩 ', '󰎬 ', '󰎮 ', '󰎰 ', '󰎵 '
        },
        -- border = true,
        -- border_virtual = true
      }
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
