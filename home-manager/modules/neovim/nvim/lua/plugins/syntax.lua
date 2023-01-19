return function(use)
  use { -- A plethora of syntaxes
    'sheerun/vim-polyglot',
    setup = function()
      vim.g.polyglot_disabled = { 'yaml', 'markdown', 'scala' }
    end,
  }

  use { 'zirrostig/vim-shbed', ft = { 'sh', 'fish' } }
  use {
    'vim-scripts/TeX-9',
    ft = { 'tex', 'latex' },
    config = function()
      vim.g.tex_nine_config = {
        compiler = 'pdflatex',
        viewer = { app = 'zathura', target = 'pdf' },
      }
    end,
  }
  use { 'neomutt/neomutt.vim', ft = 'mail' }
  use { 'pantharshit00/vim-prisma', ft = 'prisma' }
  use { 'nathangrigg/vim-beancount', ft = { '*.bean', '*.beancount' } }

  use {
    'mattn/emmet-vim',

    ft = { 'html', 'handlebars', 'css', 'less', 'sass', 'scss', 'jsx' },
    config = function()
      vim.g.user_emmet_leader_key = '<localleader>'
      vim.g.user_emmet_install_global = false
      vim.cmd [[EmmetInstall]]
    end,
  }

  use {
    'jceb/vim-orgmode',
    ft = '*.org',
    requires = { 'inkarkat/vim-SyntaxRange', ft = 'org' },
  }

  -- Markdown
  use {
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
  }
  use { -- Fancy markdown extras
    'SidOfc/mkdx',
    ft = { 'md', 'markdown' },
    config = function()
      vim.g['mkdx#settings'] = {
        map = { prefix = '<localleader>', enable = 1 },
        tokens = {
          enter = { '-', '*', '>' },
          bold = '**',
          italic = '*',
          strike = '',
          list = '-',
          fence = '',
          header = '#',
        },
        checkbox = {
          toggles = { ' ', '-', 'x' },
          update_tree = 2,
          initial_state = ' ',
        },
        highlight = { enable = 1 },
        auto_update = { enable = 1 },
        fold = { enable = 1 },
      }
    end,
  }
  use { -- make editing freetext easier
    'reedes/vim-pencil',
    ft = { 'md', 'markdown', 'text', 'mail' },
    config = function()
      vim.g.pencil_gutter_color = true
    end,
  }
  use { -- preview markdown
    'npxbr/glow.nvim',
    ft = { 'md', 'markdown' },
    cmd = 'Glow',
    config = function()
      vim.keymap.set('n', '<localleader>p', [[<Cmd>Glow<CR>]], { buffer = 0 })
    end,
  }

  -- clojure
  use { 'tpope/vim-classpath', ft = 'clojure' }
  use { -- static support for Leiningen
    'tpope/vim-salve',
    ft = 'clojure',
    requires = { 'tpope/vim-projectionist', ft = 'clojure' }, -- quick-switch between src and test
  }
  use { 'eraserhd/parinfer-rust', ft = 'clojure' }
  use { 'liquidz/vim-iced', ft = 'clojure' }

  -- lua
  use { 'milisims/nvim-luaref' }
end
