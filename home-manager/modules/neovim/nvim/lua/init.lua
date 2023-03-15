-- vim.o.undodir = vim.fn.stdpath 'cache' .. '/undo'
local cache_opts = { 'undodir', 'directory', 'backupdir', 'viewdir' }
for _, optname in ipairs(cache_opts) do
  local dirname, _ = string.gsub(optname, 'dir$', '')
  local dir = vim.fn.stdpath 'cache' .. '/' .. dirname
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
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
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

function _G.me.fn.reload_config()
  -- un-require all plugins
  for k, _ in pairs(package.loaded) do
    if string.match(k, '^plugins') then
      package.loaded[k] = nil
    end
  end
  -- prepend current vim config dir to runtimepath, source root packer config, recompile.
  vim.cmd [[
    execute ":set runtimepath^=".. expand("%:p:s?/lua/.*$??")
    lua require('plugins')
    PackerCompile
    redraw
    echomsg 'Packer compiled using surrounding neovim config.'
  ]]
end

vim.cmd [[
  augroup me
    autocmd!
  augroup END
]]
-- autocmd BufWritePost */home-manager/modules/neovim/nvim/lua/*.lua lua _G.me.fn.reload_config()

-- require 'impatient' --.enable_profile()

require 'config'
require 'commands'
require 'autocmds'
require 'keymaps'

require('lazy').setup 'plugins'
