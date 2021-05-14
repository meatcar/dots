---@diagnostic disable-next-line: undefined-global
local vim = vim
local saga = require('lspsaga')
saga.init_lsp_saga({error_sign = '', warn_sign = '', hint_sign = '', infor_sign = ''})
require("trouble").setup({
        use_lsp_diagnostic_signs = false
    })

vim.api.nvim_set_keymap('n', '<a-n>', '<cmd>lua require"illuminate".next_reference{wrap=true}<cr>', {noremap=true})
vim.api.nvim_set_keymap('n', '<a-p>', '<cmd>lua require"illuminate".next_reference{reverse=true,wrap=true}<cr>', {noremap=true})

