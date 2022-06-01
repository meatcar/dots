-- vim: set foldmethod=marker
-- Bootstrap
_G.vim = vim
local fn = vim.fn
_G.me.o.sidebars = { 'NvimTree', 'qf', 'vista_kind', 'terminal', 'packer', 'Mundo' }
local sidebars = _G.me.o.sidebars

-- bootstrap packer if not installed
local install_path = fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
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
  -- use 'kopischke/vim-stay' -- save fold states
  use 'kopischke/vim-fetch' -- handle line and column numbers in file names
  use 'airblade/vim-rooter' -- auto-cd to root directory
  use 'Konfekt/FastFold' -- speed up folding for big files
  use 'aymericbeaumet/symlink.vim' -- follow symlinks
  use 'ConradIrwin/vim-bracketed-paste' -- better paste in supported terminals
  use 'tweekmonster/startuptime.vim' -- debug slow vim startup times
  use 'lewis6991/impatient.nvim' -- cache lua compiled modules
  use 'axelf4/vim-strip-trailing-whitespace' -- strip whitespace on edited lines

  use { -- work with surrounding text
    'machakann/vim-sandwich',
    config = function()
      -- unmap s, which can easily be replaces by cl
      vim.api.nvim_set_keymap('n', 's', '<Nop>', {})
      vim.api.nvim_set_keymap('x', 's', '<Nop>', {})
    end,
  }
  use { --easy commenting with gcc
    'terrortylor/nvim-comment',
    config = function()
      require('nvim_comment').setup()
    end,
  }
  use { -- add  to function blocks
    'tpope/vim-endwise',
    config = function()
      vim.g.endwise_no_mappings = true
    end,
  }
  use { -- quickly delete multiple buffers based on the conditions provided
    'kazhala/close-buffers.nvim',
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

  use { -- easily install new lsp servers
    'williamboman/nvim-lsp-installer',
    config = function()
      local lsp_installer = require 'nvim-lsp-installer'

      lsp_installer.on_server_ready(function(server)
        local cmp = require 'cmp'
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

        server:setup {
          capabilities = capabilities,
          on_attach = _G.me.fn.keymap_lsp_on_attach,
        }
      end)
    end,
  }

  use { -- show a lightbulb for lsp actions
    'kosayoda/nvim-lightbulb',
    config = function()
      vim.cmd [[autocmd packer CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()]]
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
        code_action_prompt = {
          enable = false,
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
    'onsails/lspkind-nvim',
    config = function()
      require('lspkind').init {}
    end,
  }
end

local function completion(use)
  use {
    'hrsh7th/nvim-cmp',
    requires = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      -- 'hrsh7th/cmp-cmdline',
      'hrsh7th/nvim-cmp',
      'hrsh7th/cmp-vsnip',
      'kristijanhusak/vim-dadbod-completion',
      'lukas-reineke/cmp-under-comparator',
      'lukas-reineke/cmp-rg',
      'andersevenrud/cmp-tmux', -- Sources words from adjacent tmux panes.
    },
    config = function()
      local cmp = require 'cmp'
      cmp.setup {
        sources = {
          { name = 'path' },
          { name = 'buffer' },
          { name = 'nvim_lsp' },
          { name = 'vsnip' },
          { name = 'tmux' },
          { name = 'vim-dadbod-completion' },
          { name = 'rg' },
        },
        mapping = {
          ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
          ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          },
          ['<C-e>'] = cmp.mapping {
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
          },
          ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
          ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
        },
        snippet = {
          expand = function(args) -- REQUIRED - you must specify a snippet engine
            vim.fn['vsnip#anonymous'](args.body) -- For `vsnip` users.
          end,
        },
        sorting = {
          comparators = {
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.score,
            require('cmp-under-comparator').under,
            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
          },
        },
      }
      -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
      -- cmp.setup.cmdline('/', { sources = { { name = 'buffer' } } })

      -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
      -- cmp.setup.cmdline(':', {
      --   sources = cmp.config.sources({
      --     { name = 'path' },
      --   }, {
      --     { name = 'cmdline' },
      --   }),
      -- })
    end,
  }

  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup {
        ensure_installed = 'all',
        ignore_install = { 'swift' },
        highlight = { enable = true },
        indent = { enable = true },
      }
      vim.o.foldmethod = 'expr'
      vim.o.foldexpr = 'nvim_treesitter#foldexpr()'
    end,
  }

  use {
    'kkoomen/vim-doge',
    run = ':call doge#install()',
    config = function()
      vim.g.doge_javascript_settings = {
        destructuring_props = true,
        omit_redundant_param_types = true,
      }
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

  use { -- generate a link to file on git remote site
    'ruifm/gitlinker.nvim',
    requires = 'nvim-lua/plenary.nvim',
    config = function()
      require('gitlinker').setup()
    end,
  }

  use { -- tight git integration
    'tpope/vim-fugitive',
    config = function()
      vim.cmd [[autocmd packer FileType fugitive nmap <buffer> q gq]]
    end,
  }

  use { -- Gist support
    'mattn/vim-gist',
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

  use { -- show git changes in the gutter
    'lewis6991/gitsigns.nvim',
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
  use 'lambdalisue/suda.vim' -- :SudaWrite
  use 'AndrewRadev/splitjoin.vim' -- gS/gJ to split/join multi-line code

  use { -- run tests easily
    'janko/vim-test',
    config = function()
      if vim.env.TMUX ~= nil then
        vim.g['test#strategy'] = 'vimux'
      end
      vim.g['test#preserve_screen'] = false
    end,
  }

  use { -- associate sessions with cwd
    'rmagatti/auto-session',
    config = function()
      local dir = vim.fn.stdpath 'data' .. '/sessions/'
      vim.fn.mkdir(dir, 'p')
      require('auto-session').setup {
        auto_session_root_dir = dir,
      }
    end,
  }

  use { -- undo tree
    'simnalamburt/vim-mundo',
    cmd = 'MundoToggle',
  }

  use { -- align operations
    'junegunn/vim-easy-align',
    config = function()
      -- Start interactive EasyAlign in visual mode (e.g. vipga)
      vim.api.nvim_set_keymap('n', 'ga', '<Plug>(EasyAlign)', {})
      -- Start interactive EasyAlign for a motion/text object (e.g. gaip)
      vim.api.nvim_set_keymap('x', 'ga', '<Plug>(EasyAlign)', {})
    end,
  }

  use { -- UI for dadbod, a database UI
    'kristijanhusak/vim-dadbod-ui',
    requires = 'tpope/vim-dadbod', -- Modern database interface for Vim
  }

  use { -- editorconfig file support
    'editorconfig/editorconfig-vim',
    config = function()
      vim.g.EditorConfig_exclude_patterns = { [[fugitive://.*]] }
    end,
  }

  use { -- fuzzy completion of all the things
    'junegunn/fzf.vim',
    requires = { 'junegunn/fzf', run = './install --all' },
  }

  use { -- async error checking
    'dense-analysis/ale',
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

  use { -- nice simple file browser
    'justinmk/vim-dirvish',
    config = function()
      vim.cmd [[autocmd packer FileType dirvish sort ,^.*[\/], | silent keeppatterns g@\v/\.[^\/]+/?$@d _]]
      vim.cmd [[autocmd packer FileType dirvish nmap <buffer> q <Plug>(dirvish_quit)]]
    end,
  }

  use { -- fast file tree
    'kyazdani42/nvim-tree.lua',
    requires = 'kyazdani42/nvim-web-devicons',
    config = function()
      vim.g.nvim_tree_git_hl = true
      vim.g.nvim_tree_add_trailing = true
      require('nvim-tree').setup {
        -- disable conflict with dirvish
        update_to_buf_dir = { enable = false },
      }
    end,
  }

  use {
    'luukvbaal/nnn.nvim',
    cmd = { 'NnnPicker', 'NnnExplorer' },
    config = function()
      require('nnn').setup()
    end,
  }

  use { -- ctrl-[ax] on drugs
    'zegervdv/nrpattern.nvim',
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

  use { -- show lines for indents on blank lines
    'lukas-reineke/indent-blankline.nvim',
    config = function()
      vim.g.indent_blankline_char = '▏'
      vim.g.indent_blankline_space_char_blankline = ' '
      vim.g.indent_blankline_use_treesitter = false
      vim.g.indent_blankline_show_current_context = true
      vim.g.indent_blankline_filetype_exclude = sidebars
    end,
  }

  use { -- highlight and add UI for TODO comments
    'folke/todo-comments.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('todo-comments').setup { signs = false }
    end,
  }

  use { -- a fuzzy completion engine
    'nvim-telescope/telescope.nvim',
    requires = {
      'nvim-lua/popup.nvim',
      'nvim-lua/plenary.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
      { 'nvim-telescope/telescope-smart-history.nvim' },
    },
    config = function()
      local history_path = vim.fn.stdpath 'data' .. '/databases'
      vim.fn.mkdir(history_path, 'p')
      local trouble = require 'trouble.providers.telescope'
      require('telescope').setup {
        defaults = {
          winblend = 10,
          -- TODO: Borken, see https://github.com/nvim-telescope/telescope.nvim/issues/840
          -- sorting_strategy = 'ascending',
          layout_strategy = 'vertical',
          layout_config = {
            vertical = {
              -- TODO: set to true once sorting_strategy = ascending is fixed
              mirror = false,
            },
          },
          history = {
            path = history_path .. '/telescope_history.sqlite3',
            limit = 100,
          },
          mappings = {
            i = {
              ['<C-Down>'] = require('telescope.actions').cycle_history_next,
              ['<C-Up>'] = require('telescope.actions').cycle_history_prev,
              ['<c-t>'] = trouble.open_with_trouble,
            },
            n = { ['<c-t>'] = trouble.open_with_trouble },
          },
          cache_picker = {
            num_pickers = 1,
          },
        },
        extensions = {
          fzf = {
            fuzzy = true, -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true, -- override the file sorter
            case_mode = 'smart_case', -- or "ignore_case" or "respect_case" the default case_mode is "smart_case"
          },
        },
      }
      require('telescope').load_extension 'fzf'
      require('telescope').load_extension 'smart_history'
      vim.cmd [[
        command! Ctrlp execute (exists("*FugitiveHead()") && len(FugitiveHead())) ? 'Telescope git_files show_untracked=true' : 'Telescope find_files'
        nnoremap <C-p>      <Cmd>Ctrlp<CR>
      ]]
    end,
  }

  use { -- tmux integration
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

  use { -- open and run commands in a tmux pane
    'preservim/vimux',
    cond = function()
      return vim.env.TMUX ~= nil
    end,
  }

  use { -- fullscreen current buffer
    'folke/zen-mode.nvim',
    config = function()
      require('zen-mode').setup {}
      vim.api.nvim_set_keymap('n', '<C-w>z', '<Cmd>ZenMode<CR>', {})
      vim.api.nvim_set_keymap('n', '<Leader>wz', '<Cmd>ZenMode<CR>', {})
    end,
  }
end

local function pretty(use)
  use 'kien/rainbow_parentheses.vim'

  use 'xtal8/traces.vim'

  use 'romainl/vim-cool' -- smart set nohl after we're done searching

  use { -- smooth scrolling
    'karb94/neoscroll.nvim',
    config = function()
      require('neoscroll').setup()
    end,
  }

  use { -- flash cursor sometimes
    'edluffy/specs.nvim',
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

  use { -- highlight word under cursor
    'RRethy/vim-illuminate',
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

  use { -- pretty fold texts
    'jrudess/vim-foldtext',
    config = function()
      vim.g.FoldText_line = '' -- 
      vim.g.FoldText_multiplication = ' '
    end,
  }

  use { -- eol hints & counters when searching
    'kevinhwang91/nvim-hlslens',
    config = function()
      for _, map in ipairs { 'n', 'N' } do
        vim.api.nvim_set_keymap(
          'n',
          map,
          [[<cmd>execute('normal! ' . v:count1 . ']] .. map .. [[')<cr><cmd>lua require('hlslens').start()<cr>]],
          { noremap = true, silent = true }
        )
      end
      for _, map in ipairs { '*', '#', 'g*', 'g#' } do
        vim.api.nvim_set_keymap('n', map, map .. [[<cmd>lua require('hlslens').start()<cr>]], { noremap = true })
      end
    end,
  }
end

local function colorscheme(use)
  vim.cmd [[autocmd packer ColorScheme * lua require('lualine').setup()]]
  vim.cmd [[autocmd packer OptionSet background lua me.fn.autocmd_onOptionSetBackground()]]
  function _G.me.fn.autocmd_onOptionSetBackground()
    if vim.o.background == 'dark' then
      vim.cmd [[Catppuccin mocha]]
    else
      vim.cmd [[Catppuccin latte]]
    end
  end

  use 'liuchengxu/space-vim-theme'

  use 'NLKNguyen/papercolor-theme'

  use 'bluz71/vim-moonfly-colors'

  use {
    'https://gitlab.com/protesilaos/tempus-themes-vim', -- accessible themes
    setup = function()
      vim.g.tempus_enforce_background_color = true
    end,
  }

  use {
    'ellisonleao/gruvbox.nvim',
    requires = 'rktjmp/lush.nvim',
    setup = function()
      vim.g.gruvbox_italic = true
      vim.g.gruvbox_invert_selection = false
      vim.g.gruvbox_contrast_dark = 'hard'
      vim.g.gruvbox_sign_column = 'bg0'
      vim.g.gruvbox_color_column = 'bg0'
    end,
  }
  use {
    'marko-cerovac/material.nvim',
    setup = function()
      vim.g.material_lighter_contrast = true
    end,
  }

  use {
    'folke/tokyonight.nvim',
  }
  use {
    'projekt0n/github-nvim-theme',
    setup = function()
      vim.g.github_sidebars = sidebars
    end,
    config = function()
      -- vim.cmd [[colorscheme github_dimmed]]
    end,
  }

  use {
    'catppuccin/nvim',
    as = 'catppuccin',
    setup = function()
      vim.g.catppuccin_flavour = 'mocha' -- latte, frappe, macchiato, mocha
    end,
    config = function()
      require('catppuccin').setup {
        integrations = {
          lsp_trouble = true,
          lsp_saga = true,
          which_key = true,
          nvimtree = {
            enabled = true,
          },
        },
      }
      vim.cmd [[colorscheme catppuccin]]
    end,
  }
end

local function syntax(use)
  use { -- A plethora of syntaxes
    'sheerun/vim-polyglot',
    setup = function()
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
  use { -- Fancy markdown extras
    'SidOfc/mkdx',
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
      vim.api.nvim_buf_set_keymap(0, 'n', '<localleader>p', [[<Cmd>Glow<CR>]], { noremap = true })
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
    'which-key',
    'lualine',
    'bufferline',
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
    profile = {
      enable = true,
      threshold = 1,
    },
    -- Move to lua dir so impatient.nvim can cache it
    compile_path = _G.me.packercompiled,
  },
}
