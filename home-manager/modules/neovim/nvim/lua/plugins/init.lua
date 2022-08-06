-- vim: set foldmethod=marker
-- bootstrap packer if not installed
local fn = vim.fn
local install_path = fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  fn.system { 'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path }
  vim.api.nvim_command 'packadd packer.nvim'
end

local function load_plugins(use)
  require 'plugins/base'(use)
  require 'plugins/snippets'(use)
  require 'plugins/lsp'(use)
  require 'plugins/completion'(use)
  require 'plugins/git'(use)
  require 'plugins/utils'(use)
  require 'plugins/pretty'(use)
  require 'plugins/colorschemes'(use)
  require 'plugins/syntax'(use)

  use(require 'plugins/pkg_whichkey')
  use(require 'plugins/pkg_lualine')
  use(require 'plugins/pkg_bufferline')
end

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
  augroup packer
    autocmd!
    autocmd BufWritePost */home-manager/modules/neovim/nvim/lua/*.lua lua _G.me.fn.reload_config()
  augroup END
]]

return require('packer').startup {
  load_plugins,
  config = {
    profile = {
      enable = true,
      threshold = 1,
    },
    -- Move to lua dir so impatient.nvim can cache it
    compile_path = _G.me.packercompiled,
  },
}
