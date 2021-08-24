-- vim: set foldmethod=marker
-- Bootstrap
_G.vim = vim
local fn = vim.fn
local install_path = fn.stdpath 'data' .. '/pack/packer/start/packer.nvim'
_G.me = {}
_G.me.sidebars = { 'NvimTree', 'qf', 'vista_kind', 'terminal', 'packer' }
local sidebars = _G.me.sidebars

if fn.empty(fn.glob(install_path)) > 0 then
  fn.system { 'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path }
  vim.api.nvim_command 'packadd packer.nvim'
end
vim.cmd [[
  augroup packer
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup END
]]

local function base(use)
  use 'wbthomason/packer.nvim' -- manage self
  use 'nvim-lua/plenary.nvim' -- used by neovim packages
  use 'tpope/vim-eunuch' -- :Delete, :Move, etc
  use 'tpope/vim-repeat' -- repeat more things
  use 'tpope/vim-unimpaired' -- pairwise mappings like [b, ]b
  use 'wellle/targets.vim' -- additional text objects
  use 'pbrisbin/vim-mkdir' -- create directory when :e unknown/paths
  use 'kopischke/vim-stay' -- save fold states
  use 'kopischke/vim-fetch' -- handle line and column numbers in file names
  use 'airblade/vim-rooter' -- auto-cd to root directory
  use 'Konfekt/FastFold' -- speed up folding for big files
  use 'aymericbeaumet/symlink.vim' -- follow symlinks
  use 'ConradIrwin/vim-bracketed-paste' -- better paste in supported terminals
  use 'tweekmonster/startuptime.vim' -- debug slow vim startup times
  use {
    'machakann/vim-sandwich', -- work with surrounding text
    config = function()
      -- unmap s, which can easily be replaces by cl
      vim.api.nvim_set_keymap('n', 's', '<Nop>', {})
      vim.api.nvim_set_keymap('x', 's', '<Nop>', {})
    end,
  }
  use {
    'terrortylor/nvim-comment', --easy commenting with gcc
    config = function()
      require('nvim_comment').setup()
    end,
  }
  use {
    'tpope/vim-endwise', -- add  to function blocks
    config = function()
      vim.g.endwise_no_mappings = true
    end,
  }
  use {
    'kazhala/close-buffers.nvim', -- quickly delete multiple buffers based on the conditions provided
    config = function()
      require('close_buffers').setup {
        filetype_ignore = {}, -- Filetype to ignore when running deletions
        preserve_window_layout = { 'this' }, -- Types of deletion that should preserve the window layout
        next_buffer_cmd = function(windows)
          require('bufferline').cycle(1)
          local bufnr = vim.api.nvim_get_current_buf()

          for _, window in ipairs(windows) do
            vim.api.nvim_win_set_buf(window, bufnr)
          end
        end,
      }
    end,
  }
end

local function snippets(use)
  use 'rafamadriz/friendly-snippets'

  use {
    'hrsh7th/vim-vsnip',
    config = function()
      vim.cmd [[
      " Expand
      imap <expr> <C-j> vsnip#expandable() ? '<Plug>(vsnip-expand)' : '<C-j>'
      smap <expr> <C-j> vsnip#expandable() ? '<Plug>(vsnip-expand)' : '<C-j>'

      " Expand or jump
      imap <expr> <C-l> vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
      smap <expr> <C-l> vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'

      " Jump forward or backward
      imap <expr> <Tab> vsnip#jumpable(1) ? '<Plug>(vsnip-jump-next)' : '<Tab>'
      smap <expr> <Tab> vsnip#jumpable(1) ? '<Plug>(vsnip-jump-next)' : '<Tab>'
      imap <expr> <S-Tab> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<S-Tab>'
      smap <expr> <S-Tab> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<S-Tab>'
      ]]
    end,
  }
end

local function lsp(use)
  use 'neovim/nvim-lspconfig'

  use {
    'kabouzeid/nvim-lspinstall', -- easily install new lsp servers
    config = function()
      local function setup_servers()
        require('lspinstall').setup()
        local servers = require('lspinstall').installed_servers()
        for _, server in pairs(servers) do
          require('lspconfig')[server].setup {}
        end
      end

      setup_servers()

      -- Automatically reload after `:LspInstall <server>` so we don't have to restart neovim
      require('lspinstall').post_install_hook = function()
        setup_servers() -- reload installed servers
        vim.cmd 'bufdo e'
      end
    end,
  }

  use {
    'kosayoda/nvim-lightbulb', -- show a lightbulb for lsp actions
    config = function()
      vim.cmd [[autocmd packer CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()]]
    end,
  }

  use {
    'glepnir/lspsaga.nvim', -- pretty LSP popups
    config = function()
      require('lspsaga').init_lsp_saga {
        error_sign = '',
        warn_sign = '',
        hint_sign = '',
        infor_sign = '',
      }
    end,
  }

  use 'folke/lsp-colors.nvim'

  use {
    'folke/lsp-trouble.nvim', -- show all LSP errors
    config = function()
      require('trouble').setup {
        use_lsp_diagnostic_signs = false,
      }
    end,
  }

  use {
    'onsails/lspkind-nvim',
    config = function()
      require('lspkind').init {}
    end,
  }
end

local function completion(use)
  use {
    'hrsh7th/nvim-compe',
    requires = {
      'kristijanhusak/vim-dadbod-completion',
      {
        'andersevenrud/compe-tmux', -- Sources words from adjacent tmux panes.
        cond = function()
          return vim.env.TMUX ~= nil
        end,
      },
    },
    -- Improve performance for big files
    event = 'InsertEnter',
    cond = function()
      return vim.api.nvim_buf_line_count(0) < 2000
    end,
    config = function()
      require('compe').setup {
        source = {
          path = true,
          buffer = true,
          calc = true,
          nvim_lsp = true,
          nvim_lua = true,
          vsnip = true,
          ultisnips = true,
          luasnip = true,
          tmux = vim.env.TMUX ~= nil,
        },
      }

      -- https://github.com/hrsh7th/nvim-compe#mappings
      local opts = { noremap = true, silent = true, expr = true }
      vim.api.nvim_set_keymap('i', '<C-Space>', 'compe#complete()', opts)
      vim.api.nvim_set_keymap('i', '<CR>', [[compe#confirm('<CR>')]], opts)
      vim.api.nvim_set_keymap('i', '<C-e>', [[compe#close('<C-e>')]], opts)
      vim.api.nvim_set_keymap('i', '<C-f>', [[compe#scroll({'delta': +4})]], opts)
      vim.api.nvim_set_keymap('i', '<C-d>', [[compe#scroll({'delta': -4})]], opts)
    end,
  }

  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup {
        ensure_installed = 'all',
        highlight = { enable = true },
        indent = { enable = true },
      }
      vim.o.foldmethod = 'expr'
      vim.o.foldexpr = 'nvim_treesitter#foldexpr()'
    end,
  }
end

local function git(use)
  use 'tpope/vim-rhubarb' -- auto-complete Github issues in fugitive
  use 'samoshkin/vim-mergetool' -- Better merging (3-way becomes 2-way)
  use 'rhysd/git-messenger.vim' -- pop-up window of git commit under cursor
  use 'sodapopcan/vim-twiggy' -- pop-up git branches
  use 'rbong/vim-flog' -- pretty git log
  use 'Odie/gitabra' -- magit-like git ui
  use 'mattn/webapi-vim' -- for vim-gist
  use 'ruifm/gitlinker.nvim' -- generate a link to file on git remote site

  use {
    'tpope/vim-fugitive', -- tight git integration
    config = function()
      vim.cmd [[autocmd packer FileType fugitive nmap <buffer> q gq]]
    end,
  }

  use {
    'mattn/vim-gist', -- Gist support
    config = function()
      if vim.env.WAYLAND_DISPLAY then
        vim.g.gist_clip_command = 'wl-copy'
      else
        vim.g.gist_clip_command = 'xclip -selection clipboard'
      end
      vim.g.gist_detect_filetype = true
      vim.g.gist_open_browser_after_post = true
      vim.g.gist_browser_command = 'xdg-open %URL% &'
    end,
  }

  use {
    'lewis6991/gitsigns.nvim', -- show git changes in the gutter
    requires = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('gitsigns').setup()
    end,
  }
end

local function utilities(use)
  use 'Olical/vim-enmasse' -- mass-edit lines in quickfix
  use 'kevinhwang91/nvim-bqf' -- better quickfix window
  use 'kshenoy/vim-signature' -- show marks in the SignColumn
  use 'janko/vim-test' -- run tests easily
  use 'lambdalisue/suda.vim' -- :SudaWrite
  use 'AndrewRadev/splitjoin.vim' -- gS/gJ to split/join multi-line code
  use 'rmagatti/auto-session' -- associate sessions with cwd

  use {
    'simnalamburt/vim-mundo', -- undo tree
    cmd = 'MundoToggle',
  }

  use {
    'junegunn/vim-easy-align',
    config = function()
      -- Start interactive EasyAlign in visual mode (e.g. vipga)
      vim.api.nvim_set_keymap('n', 'ga', '<Plug>(EasyAlign)', {})
      -- Start interactive EasyAlign for a motion/text object (e.g. gaip)
      vim.api.nvim_set_keymap('x', 'ga', '<Plug>(EasyAlign)', {})
    end,
  }

  use {
    'kristijanhusak/vim-dadbod-ui', -- UI for dadbod
    requires = 'tpope/vim-dadbod', -- Modern database interface for Vim
  }

  use {
    'editorconfig/editorconfig-vim',
    config = function()
      vim.g.EditorConfig_exclude_patterns = { [[fugitive://.*]] }
    end,
  }

  use {
    'junegunn/fzf.vim', -- fuzzy completion of all the things
    requires = { 'junegunn/fzf', run = './install --all' },
  }

  use {
    'dense-analysis/ale', -- async error checking
    requires = 'desmap/ale-sensible', -- sensible ALE defaults
    config = function()
      vim.g.ale_lint_on_text_changed = 'never'
      vim.g.ale_linter_aliases = { vimwiki = 'markdown' }
      vim.g.ale_linters = { clojure = { 'clj-kondo', 'joker' } }

      vim.g.ale_fix_on_save = true
      vim.g.ale_fixers = {
        javascript = { 'eslint', 'prettier' },
        css = { 'stylelint' },
        scss = { 'stylelint' },
        python = { 'autopep8' },
        nix = { 'nixpkgs-fmt' },
        sh = { 'shfmt' },
        elixir = { 'mix_format' },
        lua = { 'stylua' },
      }
    end,
  }

  use {
    'justinmk/vim-dirvish', -- nice simple file browser
    config = function()
      vim.cmd [[autocmd packer FileType dirvish sort ,^.*[\/], | silent keeppatterns g@\v/\.[^\/]+/?$@d _]]
      vim.cmd [[autocmd packer FileType dirvish nmap <buffer> q <Plug>(dirvish_quit)]]
    end,
  }

  use {
    'kyazdani42/nvim-tree.lua', -- fast file tree
    config = function()
      vim.g.nvim_tree_git_hl = true
      vim.g.nvim_tree_add_trailing = true
    end,
  }

  use {
    'zegervdv/nrpattern.nvim', -- ctrl-[ax] on drugs
    config = function()
      -- Get the default dict of patterns
      local patterns = require 'nrpattern.default'

      -- Add a cyclic pattern (toggles between yes and no)
      patterns[{ 'yes', 'no' }] = { priority = 10 }
      patterns[{ 'True', 'False' }] = { priority = 10 }
      patterns[{ '[ ]', '[x]', '[-]' }] = { priority = 10 }

      -- Call the setup to enable the patterns
      require('nrpattern').setup(patterns)
    end,
  }

  use {
    'lukas-reineke/indent-blankline.nvim', -- show lines for indents on blank lines
    config = function()
      vim.g.indent_blankline_char = '▏'
      vim.g.indent_blankline_space_char_blankline = ' '
      vim.g.indent_blankline_use_treesitter = false
      vim.g.indent_blankline_show_current_context = true
      vim.g.indent_blankline_filetype_exclude = sidebars
    end,
  }

  use {
    'folke/todo-comments.nvim', -- highlight and add UI for TODO comments
    requires = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('todo-comments').setup { signs = false }
    end,
  }

  use {
    'nvim-telescope/telescope.nvim', -- a fuzzy completion engine
    requires = { 'nvim-lua/popup.nvim', 'nvim-lua/plenary.nvim' },
    config = function()
      require('telescope').setup {
        defaults = {
          -- TODO: Borken, see https://github.com/nvim-telescope/telescope.nvim/issues/840
          -- sorting_strategy = 'ascending',
          layout_strategy = 'vertical',
          layout_config = {
            vertical = {
              -- TODO: set to true once sorting_strategy = ascending is fixed
              mirror = false,
            },
          },
        },
      }
      vim.cmd [[
        command! Ctrlp execute (exists("*fugitive#head") && len(fugitive#head())) ? 'Telescope git_files show_untracked=true' : 'Telescope find_files'
        nnoremap <C-p>      <Cmd>Ctrlp<CR>
      ]]
    end,
  }

  use {
    'aserowy/tmux.nvim',
    cond = function()
      return vim.env.TMUX ~= nil
    end,
    config = function()
      require('tmux').setup {
        copy_sync = { enable = true },
        navigation = { enable_default_keybindings = true },
        resize = { enable_default_keybindings = true },
      }
    end,
  }

  use {
    'folke/zen-mode.nvim', -- fullscreen current buffer
    config = function()
      require('zen-mode').setup {}
      vim.api.nvim_set_keymap('n', '<C-w>z', '<Cmd>ZenMode<CR>', {})
      vim.api.nvim_set_keymap('n', '<Leader>wz', '<Cmd>ZenMode<CR>', {})
    end,
  }
end

local function pretty(use)
  use {
    'folke/which-key.nvim', --popup ui for obscure keys
    config = function()
      require 'modules/which-key'
    end,
  }

  use {
    'mhinz/vim-startify', -- startup screen
    requires = 'ryanoasis/vim-devicons', -- pretty icons
    config = function()
      local fn = vim.fn
      vim.g.startify_custom_indices = fn.map(fn.range(1, 100), 'string(v:val)') -- start with 1
      vim.g.startify_session_dir = fn.stdpath 'cache' .. '/session'
      vim.g.startify_skiplist = {
        'COMMIT_EDITMSG',
        'pack/.*/doc',
        fn.escape(fn.fnamemodify(fn.resolve(vim.env.VIMRUNTIME), ':p'), '\\') .. 'doc',
      }
      vim.g.startify_custom_footer = { '', [[   Vim is charityware. Please read ':help uganda'.]], '' }
      vim.g.startify_custom_header = {
        '',
        [[    __   _(_)_ __ ___  ]],
        [[    \ \ / / | '_ ` _ \ ]],
        [[     \ V /| | | | | | |]],
        [[   n  \_/ |_|_| |_| |_|]],
      }
      vim.g.startify_session_autoload = true
      vim.g.startify_session_persistence = true
      vim.g.startify_session_delete_buffers = true
      vim.g.startify_change_to_vcs_root = true
      vim.cmd [[autocmd packer User Startified setlocal buftype=nofile]]
      -- devicons
      vim.cmd [[
        function! StartifyEntryFormat()
            return 'WebDevIconsGetFileTypeSymbol(absolute_path) ." ". entry_path'
        endfunction
      ]]
    end,
  }

  use 'kien/rainbow_parentheses.vim'

  use 'xtal8/traces.vim'

  use {
    'karb94/neoscroll.nvim', -- smooth scrolling
    config = function()
      require('neoscroll').setup()
    end,
  }

  use {
    'akinsho/nvim-bufferline.lua', -- a pretty bufferline
    requires = 'kyazdani42/nvim-web-devicons',
    config = function()
      require 'modules/bufferline'
    end,
  }

  use {
    'edluffy/specs.nvim', -- flash cursor sometimes
    config = function()
      require('specs').setup {
        show_jumps = true,
        min_jump = 30,
        popup = {
          delay_ms = 0, -- delay before popup displays
          inc_ms = 10, -- time increments used for fade/resize effects
          blend = 10, -- starting blend, between 0-100 (fully transparent), see :h winblend
          width = 10,
          winhl = 'PMenu',
          fader = require('specs').linear_fader,
          resizer = require('specs').shrink_resizer,
        },
        ignore_filetypes = {},
        ignore_buftypes = {
          nofile = true,
        },
      }
    end,
  }

  use {
    'RRethy/vim-illuminate', -- highlight word under cursor
    config = function()
      vim.api.nvim_set_keymap(
        'n',
        '<a-n>',
        '<cmd>lua require"illuminate".next_reference{wrap=true}<cr>',
        { noremap = true }
      )
      vim.api.nvim_set_keymap(
        'n',
        '<a-p>',
        '<cmd>lua require"illuminate".next_reference{reverse=true,wrap=true}<cr>',
        { noremap = true }
      )
    end,
  }

  use {
    'jrudess/vim-foldtext', -- pretty fold texts
    config = function()
      vim.g.FoldText_line = ''
      vim.g.FoldText_multiplication = ' '
    end,
  }

  use 'romainl/vim-cool' -- smart set nohl after we're done searching
end

local function colorscheme(use)
  _G.colorscheme = {}
  use 'liuchengxu/space-vim-theme'

  use 'NLKNguyen/papercolor-theme'

  use 'bluz71/vim-moonfly-colors'

  use 'https://gitlab.com/protesilaos/tempus-themes-vim' -- accessible themes
  vim.g.tempus_enforce_background_color = true

  use {
    'npxbr/gruvbox.nvim',
    requires = 'rktjmp/lush.nvim',
  }
  vim.g.gruvbox_italic = true
  vim.g.gruvbox_invert_selection = false
  vim.g.gruvbox_contrast_dark = 'hard'
  vim.g.gruvbox_sign_column = 'bg0'
  vim.g.gruvbox_color_column = 'bg0'

  use {
    'marko-cerovac/material.nvim',
    config = function()
      _G.me.material = {}
      vim.cmd [[autocmd packer ColorSchemePre material lua me.material.onColorSchemePre()]]
      function _G.me.material.onColorSchemePre()
        _G.me.material.onOptionSetBackground()
        vim.cmd [[augroup MaterialNvim]]
        vim.cmd [[  autocmd!]]
        vim.cmd [[  autocmd OptionSet background lua me.material.onOptionSetBackground()]]
        vim.cmd [[  autocmd ColorSchemePre * au! MaterialNvim]]
        vim.cmd [[augroup END]]
      end
      function _G.me.material.onOptionSetBackground()
        local background = vim.o.background
        if background == 'dark' then
          vim.g.material_style = 'deep ocean'
        else
          vim.g.material_style = 'lighter'
        end
        vim.cmd [[colorscheme material]]
        vim.o.background = background -- restore background, since the theme always sets it to dark
      end
      vim.cmd [[colorscheme material]]
    end,
  }
  vim.g.material_lighter_contrast = true

  use {
    'folke/tokyonight.nvim',
    config = function()
      -- vim.cmd [[colorscheme tokyonight]]
    end,
  }
  if vim.o.background == 'dark' then
    vim.g.tokyonight_style = 'night'
  end

  use 'projekt0n/github-nvim-theme'
  function _G.colorscheme.github()
    vim.g.colors_name = 'github'
    require('github-theme').setup {
      themeStyle = vim.o.background,
      sidebars = sidebars,
    }
  end

  vim.cmd [[autocmd packer ColorScheme github ++nested lua colorscheme.github()]]
  vim.cmd [[autocmd packer ColorScheme * lua require('lualine').setup()]]
end

local function syntax(use)
  use {
    'sheerun/vim-polyglot', -- A plethora of syntaxes
    config = function()
      vim.g.polyglot_disabled = { 'yaml', 'markdown' }
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

    ft = { '*html*', '*handlebars*', '*css*', '*less*', '*sass*', '*scss*', '*jsx*' },
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
  use {
    'SidOfc/mkdx', -- Fancy markdown extras
    ft = { 'md', 'markdown' },
    config = function()
      vim.g['mkdx#settings'] = {
        map = { prefix = '<localleader>', enable = true },
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
        highlight = { enable = true },
        auto_update = { enable = true },
        fold = { enable = true },
      }
    end,
  }
  use {
    'reedes/vim-pencil', -- make editing freetext easier
    ft = { 'md', 'markdown', 'text', 'mail' },
    config = function()
      vim.g.pencil_gutter_color = true
    end,
  }
  use {
    'npxbr/glow.nvim', -- preview markdown
    ft = { 'md', 'markdown' },
    cmd = 'Glow',
    config = function()
      vim.api.nvim_buf_set_keymap(0, 'n', '<localleader>p', [[<Cmd>Glow<CR>]], { noremap = true })
    end,
  }

  -- clojure
  use { 'tpope/vim-classpath', ft = 'clojure' }
  use {
    'tpope/vim-salve', -- static support for Leiningen
    ft = 'clojure',
    requires = { 'tpope/vim-projectionist', ft = 'clojure' }, -- quick-switch between src and test
  }
  use { 'eraserhd/parinfer-rust', ft = 'clojure' }
  use { 'liquidz/vim-iced', ft = 'clojure' }
end

local function load_plugins(use)
  local plugins = {
    base,
    snippets,
    lsp,
    completion,
    git,
    utilities,
    pretty,
    colorscheme,
    syntax,
  }

  for _, f in ipairs(plugins) do
    f(use)
  end

  local modules = {
    'lualine',
  }
  for _, mod in ipairs(modules) do
    local M = require('modules/' .. mod)
    if M.package == nil then
      -- TODO: ERROR
      vim.cmd([[echoerr "Module ]] .. mod .. [[ doesn't have a field 'package', can't use with packer."]])
    end
    use(M.package)
  end
end

return require('packer').startup {
  load_plugins,
  config = {
    package_root = vim.fn.stdpath 'data' .. '/pack',
    display = {
      open_fn = function()
        return require('packer.util').float { border = 'single' }
      end,
    },
    profile = {
      enable = true,
      threshold = 1,
    },
  },
}
