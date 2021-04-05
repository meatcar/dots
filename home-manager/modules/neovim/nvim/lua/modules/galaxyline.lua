local vim = vim
local gl = require('galaxyline')
local gls = gl.section
local colors = require('gruvbox/colors')

local condition = require('galaxyline.condition')
local vcs = require('galaxyline.provider_vcs')
local buffer = require('galaxyline.provider_buffer')
local fileinfo = require('galaxyline.provider_fileinfo')
local diagnostic = require('galaxyline.provider_diagnostic')
local lspclient = require('galaxyline.provider_lsp')
local extension = require('galaxyline.provider_extensions')
local whitespace = require('galaxyline.provider_whitespace')
local icons = require('galaxyline.provider_fileinfo').define_file_icon()

local TRANSPARENT = 'NONE'

icons['man'] = {colors.faded_green, ''}

gls.left = {
    {
        Mode = {
            provider = function()
                local alias = {
                    n = 'NORMAL',
                    i = 'INSERT',
                    c = 'COMMAND',
                    V= 'VISUAL',
                    [''] = 'V-BLOCK'
                }
                local mode = vim.fn.mode()
                if condition.hide_in_width() then
                    mode = alias[mode]
                end
                return string.format('   %s ', mode)
            end,
            highlight = "CursorLine",
            separator = ' ',
            separator_highlight = { TRANSPARENT, TRANSPARENT },
        }
    },
    {
        GitIcon = {
            provider = function() return ' ' end,
            condition = function() return condition.check_git_workspace() and condition.hide_in_width() end,
            highlight = "DiffText",
        }
    },
    {
        GitBranch = {
            provider = vcs.get_git_branch,
            condition = function() return condition.check_git_workspace() and condition.hide_in_width() end,
            highlight = "DiffText",
            separator = ' ',
        }
    },
    {
        DiffAdd = {
            provider = vcs.diff_add,
            icon = ' ',
            condition = function() return condition.check_git_workspace() and condition.hide_in_width() end,
            highlight = "DiffAdd"
        }
    },
    {
        DiffModified = {
            provider = vcs.diff_modified,
            icon = ' ',
            condition = function() return condition.check_git_workspace() and condition.hide_in_width() end,
            highlight = "DiffChange"
        }
    },
    {
        DiffRemove = {
            provider = vcs.diff_remove,
            icon = ' ',
            condition = function() return condition.check_git_workspace() and condition.hide_in_width() end,
            highlight = "DiffDelete"
        }
    },
    {
        FileIcon = {
            provider = fileinfo.get_file_icon,
            condition = condition.buffer_not_empty,
            highlight = { fileinfo.get_file_icon_color, TRANSPARENT },
        },
    },
    {
        FileName = {
            provider = function()
                if not condition.buffer_not_empty() then return '' end
                local fname
                if condition.hide_in_width() then
                    fname = vim.fn.fnamemodify(vim.fn.expand '%', [[:~:.]])
                else
                    fname = vim.fn.expand '%:t'
                end
                if #fname == 0 then return '' end
                return fname
            end,
            highlight = { fileinfo.get_file_icon_color, TRANSPARENT},
        }
    },
    {
        FileReadonly = {
            provider = function()
                if vim.bo.readonly then return '   ' end
            end,
            highlight = 'DiffDelete',
        }
    },
    {
        FileModified = {
            provider = function()
                if vim.bo.modified then return '   ' end
            end,
            highlight = 'DiffAdd',
        }
    },
}

gls.right = {
    {
        DiagnosticError = {
            provider = diagnostic.get_diagnostic_error,
            icon = ' ',
            condition = function() return condition.check_active_lsp() and condition.hide_in_width() end,
            highlight = 'LspDiagnosticsSignError'
        },
    },
    {
        DiagnosticWarn = {
            provider = diagnostic.get_diagnostic_warn,
            icon = ' ',
            condition = function() return condition.check_active_lsp() and condition.hide_in_width() end,
            highlight = 'LspDiagnosticsSignWarning'
        },
    },
    {
        DiagnosticHint = {
            provider = diagnostic.get_diagnostic_hint,
            icon = ' ',
            condition = function() return condition.check_active_lsp() and condition.hide_in_width() end,
            highlight = 'LspDiagnosticsSignHint'
        }
    },
    {
        DiagnosticInfo = {
            provider = diagnostic.get_diagnostic_info,
            icon = ' ',
            condition = function() return condition.check_active_lsp() and condition.hide_in_width() end,
            highlight = 'LspDiagnosticsSignInformation'
        }
    },
    {
        FileFormat = {
            provider = fileinfo.get_file_format,
            icon = ' ',
            condition = function() return condition.hide_in_width() and fileinfo.get_file_format() ~= 'UNIX' end,
            highlight = "CursorLine",
            separator = ' ',
            separator_highlight = "CursorLine",
        }
    },
    {
        FileEncode = {
            provider = fileinfo.get_file_encode,
            icon = ' ',
            condition = function() return condition.hide_in_width() and fileinfo.get_file_encode() ~= ' UTF-8' end,
            highlight = "CursorLine",
            separator = ' ',
            separator_highlight = "CursorLine",
        }
    },
    {
        LineInfo = {
            provider = fileinfo.line_column,
            icon = ' ',
            highlight = "CursorLine",
            separator = ' ',
            separator_highlight = "CursorLine",
        }
    },
    {
        ScrollBar = {
            provider = fileinfo.current_line_percent,
            highlight = "CursorLine",
            separator = ' ',
        }
    },
}

gl.load_galaxyline()
