vim.o.guifont = 'Iosevka SS07:h11'
vim.g.neovide_floating_blur_amount_x = 2.0
vim.g.neovide_floating_blur_amount_y = 2.0
vim.g.neovide_cursor_vfx_mode = "pixiedust"

vim.keymap.set('v', '<C-S-c>', '"+y')         -- Copy
vim.keymap.set('n', '<C-S-v>', '"+P')         -- Paste normal mode
vim.keymap.set('v', '<C-S-v>', '"+P')         -- Paste visual mode
vim.keymap.set('c', '<C-S-v>', '<C-R>+')      -- Paste command mode
vim.keymap.set('i', '<C-S-v>', '<C-R><C-O>+') -- Paste insert mode

-- move between windows
vim.keymap.set('n', '<C-j>', '<C-w>j')
vim.keymap.set('n', '<C-k>', '<C-w>k')
vim.keymap.set('n', '<C-l>', '<C-w>l')
vim.keymap.set('n', '<C-h>', '<C-w>h')

-- resize text
vim.g.neovide_scale_factor = 1.0
vim.keymap.set("n", "<leader>w=", function()
  vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1
end, {
  desc = "Increase Window Scale"
})
vim.keymap.set("n", "<leader>w-", function()
  vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1
end, {
  desc = "Reduce Window Scale"
})
vim.keymap.set("n", "<leader>w0", function()
  vim.g.neovide_scale_factor = 1
end, {
  desc = "Reset Window Scale"
})
