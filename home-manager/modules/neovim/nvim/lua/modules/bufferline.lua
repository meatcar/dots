local M = {
  package = {
    'akinsho/bufferline.nvim', -- a pretty bufferline
    requires = 'kyazdani42/nvim-web-devicons',
    config = function()
      local groups = require 'bufferline.groups'

      vim.api.nvim_set_keymap('n', '[b', [[<Cmd>BufferLineCyclePrev<CR>]], { silent = true })
      vim.api.nvim_set_keymap('n', ']b', [[<Cmd>BufferLineCycleNext<CR>]], { silent = true })

      -- persist bufferline positions
      vim.o.sessionoptions = vim.o.sessionoptions .. ',globals'

      require('bufferline').setup {
        options = {
          view = 'multiwindow',
          numbers = 'none',
          buffer_close_icon = '',
          modified_icon = '●',
          close_icon = '',
          left_trunc_marker = '',
          right_trunc_marker = '',
          max_name_length = 18,
          max_prefix_length = 15,
          tab_size = 18,
          diagnostics = 'nvim_lsp',
          diagnostics_indicator = function(count, level)
            local icon = level:match 'error' and ' ' or ' '
            return icon .. count
          end,
          offsets = {
            { filetype = 'NvimTree', text = 'File Explorer' },
            { filetype = 'packager', text = 'Packager' },
            { filetype = 'Mundo', text = 'Undo' },
          },
          show_buffer_close_icons = true,
          persist_buffer_sort = true,
          separator_style = 'thick',
          enforce_regular_tabs = true,
          always_show_bufferline = false,
          sort_by = 'directory',
          groups = {
            options = {
              toggle_hidden_on_enter = true,
            },
            items = {
              {
                name = '  Tests',
                matcher = function(buf)
                  local patterns = { 'test%', '%.test.%', '%_spec' }
                  for _, pat in ipairs(patterns) do
                    if buf.filename:match(pat) then
                      return true
                    end
                  end
                end,
              },
              groups.builtin.ungrouped,
              {
                name = '  Docs',
                matcher = function(buf)
                  local patterns = { '%.md', '%.txt' }
                  for _, pat in ipairs(patterns) do
                    if buf.filename:match(pat) then
                      return true
                    end
                  end
                end,
              },
            },
          },
        },
        highlights = {
          buffer_selected = {
            gui = 'bold',
          },
          diagnostic_selected = {
            gui = 'bold',
          },
          info_selected = {
            gui = 'bold',
          },
          info_diagnostic_selected = {
            gui = 'bold',
          },
          warning_selected = {
            gui = 'bold',
          },
          warning_diagnostic_selected = {
            gui = 'bold',
          },
          error_selected = {
            gui = 'bold',
          },
          error_diagnostic_selected = {
            gui = 'bold',
          },
          pick_selected = {
            gui = 'bold',
          },
          pick_visible = {
            gui = 'bold',
          },
          pick = {
            gui = 'bold',
          },
        },
      }
    end,
  },
}

return M
