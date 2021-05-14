local vim = vim
local TRANSPARENT = 'NONE'
local function get_hl_color(hl_name)
    -- this only works with `set termguicolors`
    local exists, hl = pcall(vim.api.nvim_get_hl_by_name, hl_name, true)
    local color = hl.foreground or hl.background

    if (exists and color ~= nil) then
        return {
            foreground = ('#%06x'):format(hl.foreground),
            background = ('#%06x'):format(hl.background),
        }
    else
        return {foreground = TRANSPARENT, background = TRANSPARENT}
    end
end
print(vim.inspect(get_hl_color('DiffText')))

require('lualine').setup{
    options = {
        theme = 'auto',
        section_separators = {'', ''},
        component_separators = {'', ''},
    },
    sections = {
        lualine_a = {'mode'},
        lualine_b = {},
        lualine_c = {
            {'filename', file_status = true, full_path = true, shorten = true},
        },
        lualine_x = {
            {'diagnostics', { sources = {'nvim_lsp', 'ale'}}},
            {'diff', symbols = {added = ' ', modified = ' ', removed = ' '}}
        },
        lualine_y = {
            {'branch', color = {fg = get_hl_color('DiffText').foreground}},
            {'encoding', condition=function() return vim.o.encoding ~= 'utf-8' end},
            {'fileformat', condition=function() return vim.o.fileformat ~= 'unix' end},
            {'filetype'}
        },
        lualine_z = {'progress','location'}
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {'filename'},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {'location'}
    },
    extensions = { 'nvim-tree', 'fugitive' },
}
