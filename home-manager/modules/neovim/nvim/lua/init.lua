vim.loader.enable() -- speed up lua file loading

vim.g.parinfer_dylib_path = table.concat { vim.fn.stdpath 'data', '/lib/libparinfer_rust.so' }
vim.g.sqlite_clib_path = table.concat { vim.fn.stdpath 'data', '/lib/libsqlite3.so' }

-- vim.o.undodir = vim.fn.stdpath 'cache' .. '/undo'
local cache_opts = { 'undodir', 'directory', 'backupdir', 'viewdir' }
for _, optname in ipairs(cache_opts) do
  local dirname, _ = string.gsub(optname, 'dir$', '')
  local dir = table.concat({ vim.fn.stdpath 'cache', dirname }, '/')
  vim.o[optname] = dir
  if not vim.fn.isdirectory(dir) then
    vim.fn.mkdir(dir, 'p')
  end
end

if vim.g.vscode then
  print 'vscode'
  return
end

_G.me = {
  o = {},
  fn = {},
}

-- bootstrap lazy.nvim if not installed
local lazypath = table.concat { vim.fn.stdpath 'data', '/lazy/lazy.nvim' }
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

require 'core/options'
require 'core/commands'
require('core/autocmds').main()
if vim.g.neovide then
  print 'neovide'
  require 'core/gui'
end

-- predefine lazyloading events for consistency
_G.me.o.events = {
  verylazy = 'VeryLazy',
  buf_early = { 'BufReadPre', 'BufNewFile' },
  buf_late = { "BufReadPost", "BufNewFile" },
  insert = 'InsertEnter',
}

require('lazy').setup('plugins', {
  defaults = { lazy = true },
  performance = { reset_packpath = false } -- needed to source nixos-installed plugins
})

require 'core/notes'

require('core/keymaps').main()
