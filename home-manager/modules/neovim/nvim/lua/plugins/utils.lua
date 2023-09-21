return {
  { -- mass-edit lines in quickfix
    'Olical/vim-enmasse',
    cmd = 'EnMasse',
  },
  { 'kevinhwang91/nvim-bqf', ft = 'qf' },                    -- better quickfix window
  { 'kshenoy/vim-signature', event = me.o.events.verylazy }, -- show marks in the SignColumn
  { 'lambdalisue/suda.vim',  cmd = 'SudaWrite' },            -- save file with sudo

  {                                                          -- run tests easily
    'janko/vim-test',
    config = function()
      if vim.env.TMUX ~= nil then
        vim.g['test#strategy'] = 'vimux'
      end
      vim.g['test#preserve_screen'] = false
    end,
  },

  { -- associate sessions with cwd
    'rmagatti/auto-session',
    lazy = false,
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('auto-session').setup {
        session_lens = {
          load_on_setup = false,
        }
      }
    end,
  },

  { -- undo tree
    'simnalamburt/vim-mundo',
    cmd = 'MundoToggle',
  },

  { -- align operations
    'junegunn/vim-easy-align',
    cmd = { 'EasyAlign', 'LiveEasyAlign' },
    keys = {
      -- Start interactive EasyAlign in visual mode (e.g. vipga)
      -- Start interactive EasyAlign for a motion/text object (e.g. gaip)
      { 'ga', '<Plug>(EasyAlign)', mode = { 'n', 'x' } },
    }
  },

  { -- UI for dadbod, a database UI
    'kristijanhusak/vim-dadbod-ui',
    dependencies = {
      { 'tpope/vim-dadbod' },
      { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' } },
    },
    cmd = { 'DBUI', 'DBUIToggle', 'DBUIAddConnection', 'DBUIFindBuffer', },
    init = function()
      vim.g.db_ui_use_nerd_fonts = true
    end,
  },

  {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v3.x',
    dependencies = { 'MunifTanjim/nui.nvim', },
    cmd = 'Neotree',
    keys = {
      { '<leader>ftt', '<cmd>Neotree toggle<CR>',                   desc = 'Toggle' },
      { '<leader>ftf', '<Cmd>Neotree filesystem reveal_file=%<CR>', desc = 'Find file' },
    },
    init = function()
      -- Unless you are still migrating, remove the deprecated commands from v1.x
      vim.cmd [[ let g:neo_tree_remove_legacy_commands = 1 ]]
    end,
    opts = {
      hijack_netrw_behavior = 'disabled',
      add_blank_line_at_top = false,
      auto_clean_after_session_restore = true,
      source_selector = {
        winbar = true,
        statusline = false,
        sources = {
          { source = 'filesystem', display_name = ' 󰉓  Files ' },
          { source = 'buffers', display_name = ' 󱒋  Buffers ' },
          { source = 'git_status', display_name = ' 󰊢  Git ' },
          { source = 'diagnostics', display_name = ' 󱠂  LSP' },
          { source = 'document_symbols', display_name = ' 󱘎  Outline ' },
        },
        content_layout = 'center',
        tabs_layout = 'equal',
        truncation_character = '…',
        tabs_min_width = nil,
        tabs_max_width = nil,
        padding = 0,
      },
    },
  },

  {
    'luukvbaal/nnn.nvim',
    cmd = { 'NnnExplorer', 'NnnPicker' },
    opts = {
      explorer = { cmd = 'nnn -C -G' },
      picker = { cmd = 'nnn -G -C', style = { border = 'rounded' } },
      replace_netrw = 'picker',
    },
  },

  { -- ctrl-[ax] on drugs
    'zegervdv/nrpattern.nvim',
    event = me.o.events.buf_early,
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
  },

  { -- show lines for indents on blank lines
    'lukas-reineke/indent-blankline.nvim',
    event = me.o.events.buf_early,
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
  },

  { -- highlight and add UI for TODO comments
    'folke/todo-comments.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    event = me.o.events.buf_early,
    opts = { signs = false },
  },

  { -- a fuzzy completion engine
    'nvim-telescope/telescope.nvim',
    dependencies = {
      'nvim-lua/popup.nvim',
      'nvim-lua/plenary.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim',    build = 'make' },
      { 'nvim-telescope/telescope-smart-history.nvim', dependencies = 'kkharji/sqlite.lua' },
    },
    cmd = 'Telescope',
    init = function()
      vim.cmd [[
        command! Ctrlp execute (exists("*FugitiveHead()") && len(FugitiveHead())) ? 'Telescope git_files show_untracked=true' : 'Telescope find_files'
      ]]
    end,
    keys = {
      { '<C-p>', '<Cmd>Ctrlp<CR>' },
    },
    config = function()
      local history_path = table.concat { vim.fn.stdpath 'data', '/databases' }
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
              width = function(_self, max_columns, _max_lines)
                if max_columns < 80 then
                  return max_columns
                else
                  return 80
                end
              end,
            },
          },
          history = {
            path = table.concat { history_path, '/telescope_history.sqlite3' },
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
            fuzzy = true,                   -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true,    -- override the file sorter
            case_mode = 'smart_case',       -- or "ignore_case" or "respect_case" the default case_mode is "smart_case"
          },
        },
      }
      require('telescope').load_extension 'fzf'
      require('telescope').load_extension 'smart_history'
    end,
  },

  { -- tmux integration
    'aserowy/tmux.nvim',
    event = me.o.events.verylazy,
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
  },

  { -- open and run commands in a tmux pane
    'preservim/vimux',
    event = me.o.events.verylazy,
    cond = function()
      return vim.env.TMUX ~= nil
    end,
  },

  { -- fullscreen current buffer
    'folke/zen-mode.nvim',
    cmd = 'ZenMode',
    config = function()
      require('zen-mode').setup {}
      vim.keymap.set('n', '<C-w>z', '<Cmd>ZenMode<CR>')
      vim.keymap.set('n', '<Leader>wz', '<Cmd>ZenMode<CR>')
    end,
  },

  { -- color highlighter
    'norcalli/nvim-colorizer.lua',
    event = me.o.events.verylazy,
    config = function()
      require('colorizer').setup()
    end,
  },

  { -- split/join code using treesitter
    'Wansmer/treesj',
    keys = {
      {
        '<localleader>jj',
        function()
          require('treesj').toggle()
        end,
        desc = 'split/join toggle',
      },
      {
        '<localleader>jS',
        function()
          require('treesj').split()
        end,
        desc = 'split',
      },
      {
        '<localleader>jJ',
        function()
          require('treesj').join()
        end,
        desc = 'join',
      },
    },
    opts = { use_default_keymaps = false },
  },

  {
    'jackMort/ChatGPT.nvim',
    dependencies = {
      'MunifTanjim/nui.nvim',
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
    },
    cmd = {
      'ChatGPT',
      'ChatGPTActAs',
      'ChatGPTEditWithInstructions',
      'ChatGPTRun',
    },
    keys = {
      { '<leader>acc', '<cmd>ChatGPT<cr>',                     desc = 'ChatGPT' },
      { '<leader>aca', '<cmd>ChatGPTActAs<cr>',                desc = 'ChatGPT Act-As' },
      { '<leader>ace', '<cmd>ChatGPTEditWithInstructions<cr>', desc = 'ChatGPT Edit' },
      { '<leader>acr', '<cmd>ChatGPTRun<cr>',                  desc = 'ChatGPT Run' },
    },
    config = function()
      require('chatgpt').setup()
    end,
  },

  {
    'Bryley/neoai.nvim',
    dependencies = {
      'MunifTanjim/nui.nvim',
    },
    cmd = {
      'NeoAI',
      'NeoAIOpen',
      'NeoAIClose',
      'NeoAIToggle',
      'NeoAIContext',
      'NeoAIContextOpen',
      'NeoAIContextClose',
      'NeoAIInject',
      'NeoAIInjectCode',
      'NeoAIInjectContext',
      'NeoAIInjectContextCode',
    },
    config = function()
      require('neoai').setup {
        shortcuts = {
          name = 'textify',
          desc = 'NeoAI fix text with AI',
          use_context = true,
          prompt = [[
                    Please rewrite the text to make it more readable, clear,
                    concise, and fix any grammatical, punctuation, or spelling
                    errors
                ]],
          modes = { 'v' },
          strip_function = nil,
        },
        {
          name = 'gitcommit',
          desc = 'NeoAI generate git commit message',
          use_context = false,
          prompt = function()
            return [[
                        Using the following git diff generate a consise and
                        clear git commit message, with a short title summary
                        that is 75 characters or less:
                    ]] .. vim.fn.system 'git diff --cached'
          end,
          modes = { 'n' },
          strip_function = nil,
        },
      }
    end,
  },

  { -- open browser with various queries
    'lalitmee/browse.nvim',
    keys = {
      { '<leader>obb', function() require('browse').browse() end,                       desc = 'Browse' },
      { '<leader>obs', function() require('browse').input_search() end,                 desc = 'Search' },
      { '<leader>obd', function() require('browse.devdocs').search() end,               desc = 'DevDocs' },
      { '<leader>obD', function() require('browse.devdocs').search_with_filetype() end, desc = 'DevDocs Filetype' },
      { '<leader>obm', function() require('browse.mdn').search() end,                   desc = 'MDN' },
    },
    opts = {
      provider = 'duckduckgo'
    },
    {
      'epwalsh/obsidian.nvim',
      cmd = {
        'ObsidianOpen', 'ObsidianNew',
        'ObsidianQuickSwitch',
        'ObsidianFollowLink', 'ObsidianBacklinks',
        'ObsidianToday', 'ObsidianYesterday',
        'ObsidianTemplate',
        'ObsidianSearch',
        'ObsidianLink', 'ObsidianLinkNew',
      },
      keys = {
        { '<leader>ny', '<Cmd>ObsidianYesterday<CR>',  desc = 'Journal yesterday' },
        { '<leader>nl', '<Cmd>ObsidianLinkNew<Space>', desc = 'Link to a note' },
      },
      config = function()
        ---@diagnostic disable-next-line: missing-fields
        require('obsidian').setup {
          dir = vim.fn.environ().NOTES_DIR,
          daily_notes = {
            folder = "journal/daily"
          },
          mappings = {
            -- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
            ["gf"] = require("obsidian.mapping").gf_passthrough(),
          },
          note_id_func = require('core/notes').notename,
          templates = {
            subdir = "templates",
            date_format = "%Y-%m-%d",
            time_format = "%H:%M",
          },
        }
      end
    }
  },
}
