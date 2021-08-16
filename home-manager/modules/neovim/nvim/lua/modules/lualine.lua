local M = {
  theme = 'auto',
  themes = {},
  package = {
    'shadmansaleh/lualine.nvim', -- status line
    requires = 'kyazdani42/nvim-web-devicons',
  },
}

M.set_theme = function()
  local M = require 'modules/lualine'
  local colors_name = vim.g.colors_name
  local theme = M.themes[colors_name]
  if theme == nil then
    theme = 'auto'
  end
  M.theme = theme
  package.loaded['lualine.themes.' .. M.theme] = nil
  M.config()
end

function M.get_hl_color(hl_name)
  -- this only works with
  local exists, hl = pcall(vim.api.nvim_get_hl_by_name, hl_name, true)
  local color = hl.foreground and hl.background

  if exists and color then
    return {
      foreground = ('#%06x'):format(hl.foreground),
      background = ('#%06x'):format(hl.background),
    }
  else
    return { foreground = 'NONE', background = 'NONE' }
  end
end

function M.config()
  local M = M
  if M == nil then
    M = require 'modules/lualine'
  end
  -- vim.cmd('echomsg "lualine loaded with theme ' .. M.theme .. '"')

  -- unload theme
  package.loaded['lualine.themes.' .. M.theme] = nil

  local sections = {
    lualine_a = { 'mode' },
    lualine_b = {
      {
        'branch',
        color = { fg = M.get_hl_color('DiffText').foreground },
      },
    },
    lualine_c = {
      {
        'diff',
        symbols = { added = ' ', modified = ' ', removed = ' ' },
      },
      {
        'filename',
        file_status = true,
        path = 1,
        symbols = { modified = ' ', readonly = ' ' },
      },
    },
    lualine_x = {
      { 'diagnostics', sources = { 'nvim_lsp', 'ale' } },
      { 'filetype' },
      {
        'encoding',
        condition = function()
          return vim.o.encoding ~= 'utf-8'
        end,
      },
      {
        'fileformat',
        condition = function()
          return vim.o.fileformat ~= 'unix'
        end,
      },
    },
    lualine_y = { 'progress' },
    lualine_z = { 'location' },
  }

  vim.cmd [[
    augroup mod_lualine
      autocmd!
      autocmd ColorScheme * lua require('modules/lualine').set_theme()
    augroup END
  ]]

  return require('lualine').setup {
    options = {
      theme = M.theme,
      section_separators = '',
      component_separators = '',
    },
    sections = sections,
    inactive_sections = {
      lualine_a = {},
      lualine_b = { vim.deepcopy(sections.lualine_b[1]) },
      lualine_c = { vim.deepcopy(sections.lualine_c[2]) },
      lualine_x = {},
      lualine_y = vim.deepcopy(sections.lualine_y),
      lualine_z = vim.deepcopy(sections.lualine_z),
    },
    extensions = { 'nvim-tree', 'fugitive' },
  }
end

M.package.config = M.config

return M
