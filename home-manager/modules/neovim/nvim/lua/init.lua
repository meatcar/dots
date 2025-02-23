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

_G.me = {
  o = {},
  fn = {},
}

if vim.g.vscode then
  print 'vscode'
  require('core/vscode')
  return
end

-- bootstrap lazy.nvim if not installed
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
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

require('lazy').setup({
  spec = {
    { import = "plugins" }
  },
  defaults = { lazy = true },
  checker = { enabled = false },
  performance = {
    reset_packpath = false, -- needed to source nixos-installed plugins
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

require 'core/notes'

require('core/keymaps').main()
