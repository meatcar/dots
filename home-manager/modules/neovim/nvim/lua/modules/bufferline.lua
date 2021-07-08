require('bufferline').setup {
  options = {
    view = 'multiwindow',
    numbers = 'none',
    number_style = '',
    mappings = false,
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
      local icon = level:match 'error' and ' ' or ''
      return ' ' .. icon .. count
    end,
    offsets = {
      { filetype = 'NvimTree', text = 'File Explorer' },
      { filetype = 'packager', text = 'Packager' },
    },
    show_buffer_close_icons = true,
    persist_buffer_sort = true,
    separator_style = 'slant',
    enforce_regular_tabs = true,
    always_show_bufferline = false,
    sort_by = 'directory',
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

vim.api.nvim_set_keymap('n', '[b', [[<Cmd>BufferLineCyclePrev<CR>]], { silent = true })
vim.api.nvim_set_keymap('n', ']b', [[<Cmd>BufferLineCycleNext<CR>]], { silent = true })

-- persist bufferline positions
vim.o.sessionoptions = vim.o.sessionoptions .. ',globals'
