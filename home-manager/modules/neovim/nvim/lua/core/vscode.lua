-- Sync vim yanking with system clipboard
vim.o.clipboard = "unnamedplus"

vim.keymap.set('x', 'gc', '<Plug>VSCodeCommentary', {})
vim.keymap.set('n', 'gc', '<Plug>VSCodeCommentary', {})
vim.keymap.set('o', 'gc', '<Plug>VSCodeCommentary', {})
vim.keymap.set('n', 'gcc', '<Plug>VSCodeCommentaryLine', {})
vim.keymap.set('n', '<Space>', function() require('vscode').action('vspacecode.space') end)
vim.keymap.set('x', '<Space>', function() require('vscode').action('vspacecode.space') end, { remap = true })
