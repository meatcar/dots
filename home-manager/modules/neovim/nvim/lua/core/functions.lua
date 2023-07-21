local M = {}

M.reload_nvim_config = function(e)
  -- get lua module name, with a . as a separator for easier regex matching
  local module = vim.fn.expand('%:r:s?.*/nvim/lua/??'):gsub('/', '.')

  -- vim.cmd.redraw() -- clear screen from

  -- un-require module
  for k, _ in pairs(package.loaded) do
    if string.match(k, module) then
      package.loaded[k] = nil
    end
  end

  -- prepend current vim config dir to runtimepath, source root config
  vim.opt.rtp:prepend(vim.fn.expand '%:p:s?/lua/.*$??')
  if string.match(module, '^plugins') then
    -- require('lazy').setup 'plugins'
  end

  -- re-source module
  vim.cmd.source '%'

  vim.notify('Reloaded ' .. module)
end

M.cmd_term = function(opts)
  local cmd = 'terminal'
  if opts.bang then
    cmd = ('%s!').format(cmd)
  end

  local args = ''
  if #opts.args > 0 then
    args = ('-c "%s"').format(table.concat(opts.args, ' '))
  end

  vim.fn.execute(table.concat({ cmd, vim.env.SHELL, args }, ' '))
end

return M
