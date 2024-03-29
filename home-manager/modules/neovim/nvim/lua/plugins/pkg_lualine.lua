return {
  'nvim-lualine/lualine.nvim', -- status line
  event = me.o.events.verylazy,
  config = function()
    local mode_map = {
      ['NORMAL'] = 'N',
      ['INSERT'] = 'I',
      ['SELECT'] = 'S',
      ['COMMAND'] = 'C',
      ['VISUAL'] = 'V',
      ['V-LINE'] = 'VL',
      ['V-BLOCK'] = 'VB',
      ['REPLACE'] = 'R',
      ['TERMINAL'] = 'T',
    }

    local function gitsigns_diff()
      local gitsigns = vim.b.gitsigns_status_dict
      if gitsigns then
        return {
          added = gitsigns.added,
          modified = gitsigns.changed,
          removed = gitsigns.removed,
        }
      end
    end

    local parts = {
      filetype = {
        'filetype',
        on_click = function()
          vim.cmd [[ Telescope filetypes ]]
        end,
      },
      fileicon = {
        'filetype',
        icon_only = true,
        on_click = function()
          vim.cmd [[ Telescope filetypes ]]
        end,
      },
      filename = {
        'filename',
        file_status = true,
        path = 1,
        symbols = { modified = ' ', readonly = ' ' },
      },
      diagnostics = {
        'diagnostics',
        sources = { 'nvim_diagnostic', 'ale' },
        on_click = function()
          -- vim.diagnostic.setqflist()
          local diag = vim.diagnostic.config()
          vim.diagnostic.config {
            virtual_lines = not diag.virtual_lines,
            virtual_text = not diag.virtual_text,
          }
        end,
      },
      encoding = {
        'encoding',
        cond = function()
          return vim.o.encoding ~= 'utf-8'
        end,
      },
      fileformat = {
        'fileformat',
        cond = function()
          return vim.o.fileformat ~= 'unix'
        end,
      },
      diff = {
        'diff',
        source = gitsigns_diff,
        fmt = function(s)
          return string.gsub(s, ' ', '')
        end,
        on_click = function()
          vim.cmd [[ Gitsigns toggle_linehl ]]
          vim.cmd [[ Gitsigns toggle_deleted ]]
        end,
      },
      branch = {
        'b:gitsigns_head',
        icon = '',
        on_click = function()
          vim.cmd [[ Git ]]
        end,
      },
      mode = {
        'mode',
        fmt = function(s)
          local ret = mode_map[s]
          if ret == nil then
            return s
          end
          return ret
        end,
      },
      progress = {
        function()
          local current_line = vim.fn.line '.'
          local total_lines = vim.fn.line '$'
          local chars = { '__', '▁▁', '▂▂', '▃▃', '▄▄', '▅▅', '▆▆', '▇▇', '██' }
          local line_ratio = current_line / total_lines
          local index = math.ceil(line_ratio * #chars)
          return chars[index]
        end,
        padding = { left = 0, right = 1 },
        separator = '',
      },
      location = {
        'location',
        separator = '',
      },
    }

    local winbar = {
      lualine_a = { parts.filetype },
      lualine_b = { parts.encoding, parts.fileformat },
      lualine_c = {},
      lualine_x = { parts.diagnostics },
      lualine_y = { parts.diff },
      lualine_z = { parts.branch },
    }

    local sections = {
      lualine_a = { parts.mode },
      lualine_b = { parts.filetype, parts.encoding, parts.fileformat },
      lualine_c = { parts.filename },
      lualine_x = { parts.diagnostics },
      lualine_y = { parts.diff },
      lualine_z = { parts.location, parts.progress },
    }

    local sections_sparse = {
      lualine_a = { parts.mode },
      lualine_b = { parts.fileicon },
      lualine_c = { parts.filename },
      lualine_x = {},
      lualine_y = {},
      lualine_z = { parts.location, parts.progress },
    }

    local sections_global = {
      lualine_a = { parts.mode },
      lualine_b = {},
      lualine_c = {},
      lualine_x = { '' },
      lualine_y = {},
      lualine_z = { parts.branch },
    }

    -- require('tabline').setup { enable = false }

    vim.cmd [[autocmd me ColorScheme * lua require('lualine').setup()]]

    return require('lualine').setup {
      options = {
        theme = 'auto',

        section_separators = { left = '', right = '' },
        -- section_separators = { left = '', right = '' },
        component_separators = { left = '', right = '' },
        disabled_filetypes = {
          winbar = _G.me.o.panels,
        },
        globalstatus = false,
      },

      sections = sections,
      inactive_sections = sections,
      -- winbar = winbar,
      -- inactive_winbar = winbar,
      tabline = {},

      extensions = { 'nvim-tree', 'fugitive', 'mundo', 'man', 'quickfix' },
    }
  end,
}
