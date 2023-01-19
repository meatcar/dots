return function(use)
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
      vim.keymap.set('n', 'ga', '<Plug>(EasyAlign)')
      -- Start interactive EasyAlign for a motion/text object (e.g. gaip)
      vim.keymap.set('x', 'ga', '<Plug>(EasyAlign)')
    end,
  }

  use { -- UI for dadbod, a database UI
    'kristijanhusak/vim-dadbod-ui',
    requires = 'tpope/vim-dadbod', -- Modern database interface for Vim
    setup = function()
      vim.g.db_ui_use_nerd_fonts = true
    end,
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
        go = { 'gofmt' },
      }
    end,
  }

  use { -- fast file tree
    'kyazdani42/nvim-tree.lua',
    requires = 'kyazdani42/nvim-web-devicons',
    config = function()
      require('nvim-tree').setup {
        -- disable conflict with dirvish
        hijack_netrw = true,
        renderer = {
          highlight_git = true,
          add_trailing = true,
        },
      }
    end,
  }

  use { -- buffer-replacing file browser
    'stevearc/oil.nvim',
    requires = 'kyazdani42/nvim-web-devicons',
    config = function()
      require('oil').setup {
        columns = {
          'icon',
          'permissions',
          'size',
          'mtime',
        },
        -- Window-local options to use for oil buffers
        win_options = {
          wrap = false,
          signcolumn = 'no',
          cursorcolumn = false,
          foldcolumn = '0',
          spell = false,
          list = false,
          conceallevel = 3,
          concealcursor = 'n',
        },
        -- Restore window options to previous values when leaving an oil buffer
        restore_win_options = true,
        -- Skip the confirmation popup for simple operations
        skip_confirm_for_simple_edits = false,
        -- Keymaps in oil buffer. Can be any value that `vim.keymap.set` accepts OR a table of keymap
        -- options with a `callback` (e.g. { callback = function() ... end, desc = "", nowait = true })
        -- Additionally, if it is a string that matches "action.<name>",
        -- it will use the mapping at require("oil.action").<name>
        -- Set to `false` to remove a keymap
        keymaps = {
          ['g?'] = 'actions.show_help',
          ['<CR>'] = 'actions.select',
          ['<C-v>'] = 'actions.select_vsplit',
          ['<C-h>'] = 'actions.select_split',
          ['<C-t>'] = 'actions.open_terminal',
          ['<Esc>'] = 'actions.close',
          ['q'] = 'actions.close',
          ['gq'] = 'actions.close',
          ['<C-l>'] = 'actions.refresh',
          ['-'] = 'actions.parent',
          ['_'] = 'actions.open_cwd',
          ['`'] = 'actions.cd',
          ['~'] = 'actions.tcd',
          ['g.'] = 'actions.toggle_hidden',
        },
        -- Set to false to disable all of the above keymaps
        use_default_keymaps = true,
        view_options = {
          -- Show files and directories that start with "."
          show_hidden = false,
        },
        -- Configuration for the floating window in oil.open_float
        float = {
          -- Padding around the floating window
          padding = 2,
          max_width = 0,
          max_height = 0,
          border = 'rounded',
          win_options = {
            winblend = 10,
          },
        },
      }
      vim.keymap.set('n', '-', require('oil').open, { desc = 'Open parent directory' })
    end,
  }

  use {
    'luukvbaal/nnn.nvim',
    cmd = { 'NnnPicker', 'NnnExplorer' },
    config = function()
      require('nnn').setup {
        explorer = { cmd = 'nnn -G' },
        picker = { cmd = 'nnn -G' },
      }
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
      require('indent_blankline').setup {
        char_list = { '¦', '┆', '┊', '▏' },
        space_char_blankline = ' ',
        use_treesitter = true,
        show_current_context = true,
        show_current_context_start = true,
        filetype_exclude = _G.me.o.sidebars,
      }
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
          dynamic_preview_title = true,
          sorting_strategy = 'ascending',
          layout_strategy = 'vertical',
          layout_config = {
            flex = {
              flip_columns = 120,
              vertical = {
                width = 0.9999,
                anchor = 'SW',
              },
              horizontal = {
                anchor = 'SW',
              },
            },
            vertical = {
              anchor = 'N',
              mirror = true,
              prompt_position = 'top',
              width = function(self, max_columns, max_lines)
                if max_columns < 80 then
                  return max_columns
                else
                  return 80
                end
              end,
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
      vim.keymap.set('n', '<C-w>z', '<Cmd>ZenMode<CR>')
      vim.keymap.set('n', '<Leader>wz', '<Cmd>ZenMode<CR>')
    end,
  }

  use { -- color highlighter
    'norcalli/nvim-colorizer.lua',
    config = function()
      require('colorizer').setup()
    end,
  }
end
