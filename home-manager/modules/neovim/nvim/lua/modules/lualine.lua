---@diagnostic disable-next-line: undefined-global
local vim = vim
local TRANSPARENT = 'NONE'
local function get_hl_color(hl_name)
    -- this only works with `set termguicolors`
    local exists, hl = pcall(vim.api.nvim_get_hl_by_name, hl_name, true)
    local color = hl.foreground and hl.background

    if (exists and color) then
        return {
            foreground = ('#%06x'):format(hl.foreground),
            background = ('#%06x'):format(hl.background),
        }
    else
        return {foreground = TRANSPARENT, background = TRANSPARENT}
    end
end

local sections = {
    lualine_a = {'mode'},
    lualine_b = {
        {'branch', color = {fg = get_hl_color('DiffText').foreground}},
    },
    lualine_c = {
        {'diff', symbols = {added = ' ', modified = ' ', removed = ' '}},
        {'filename', file_status = true, path = 1, symbols = {modified = ' ', readonly = ' '}},
    },
    lualine_x = {
        {'diagnostics', sources = {'nvim_lsp', 'ale'}},
        {'filetype'},
        {'encoding', condition=function() return vim.o.encoding ~= 'utf-8' end},
        {'fileformat', condition=function() return vim.o.fileformat ~= 'unix' end},
    },
    lualine_y = {
        'progress'

    },
    lualine_z = {'location'}
}

require('lualine').setup{
    options = {
        theme = 'tokyonight',
        section_separators = {'', ''},
        component_separators = {'', ''}
    },
    sections = sections,
    inactive_sections = {
        lualine_a = {},
        lualine_b = {vim.deepcopy(sections.lualine_b[1])},
        lualine_c = {vim.deepcopy(sections.lualine_c[2])},
        lualine_x = {},
        lualine_y = {},
        lualine_z = vim.deepcopy(sections.lualine_z)
    },
    extensions = { 'nvim-tree', 'fugitive' },
}
