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

-- require 'impatient' --.enable_profile()

require 'config'
require 'commands'
require 'autocmds'
require 'keymaps'

_G.me.o.packercompiled = vim.fn.stdpath 'config' .. '/lua/packer_compiled.lua'
require 'plugins'
if vim.fn.filereadable(_G.me.o.packercompiled) == 1 then
  require 'packer_compiled'
end
