return {
  'nvim-lua/popup.nvim',
  { 'nvim-telescope/telescope-fzf-native.nvim',    build = 'make' },
  { 'nvim-telescope/telescope-smart-history.nvim', dependencies = 'kkharji/sqlite.lua' },

  { -- a fuzzy completion engine
    'nvim-telescope/telescope.nvim',
    cmd = 'Telescope',
    init = function()
      vim.cmd [[
        command! Ctrlp execute (exists("*FugitiveHead()") && len(FugitiveHead())) ? 'Telescope git_files show_untracked=true' : 'Telescope find_files'
      ]]
    end,
    keys = {
      { '<C-p>',      '<Cmd>Ctrlp<CR>' },
      { '<leader>tt', '<Cmd>Telescope resume<CR>',                 desc = 'Telescope' },
      { '<C-t>',      '<Cmd>Telescope quickfix<CR><Cmd>cclose<CR>' },
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
          layout_strategy = 'flex',
          layout_config = {
            flex = {
              flip_columns = 120,
              vertical = {
              },
            },
            vertical = {
              anchor = 'N',
              mirror = true,
              prompt_position = 'top',
              width = function(_, max_columns, _)
                if max_columns < 80 then
                  return max_columns
                elseif max_columns <= 96 then
                  return 80
                elseif max_columns < 120 then
                  return math.floor(max_columns * 0.8)
                else
                  return 120
                end
              end,
            },
            horizontal = {
              anchor = 'N',
              prompt_position = 'top'
            }
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
              -- FIX: prevent entering insert mode after opening a file with Telescope
              -- source: https://github.com/nvim-telescope/telescope.nvim/issues/2501#issuecomment-1562937344
              ["<CR>"] = function()
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc><CR>", true, false, true), "i", false)
              end,
              ["<C-x>"] = function()
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc><C-x>", true, false, true), "i", false)
              end,
              ["<C-v>"] = function()
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc><C-v>", true, false, true), "i", false)
              end,
              ["<C-t>"] = function()
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc><C-t>", true, false, true), "i", false)
              end,
              ["<C-q>"] = function()
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc><C-q>", true, false, true), "i", false)
              end,
              ["<M-q>"] = function()
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc><M-q>", true, false, true), "i", false)
              end,
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
  }
}
