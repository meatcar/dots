vim.cmd [[ command! -nargs=* -bang -complete=shellcmd Term :lua me.fn.cmd_term(<q-bang> ~= '!', <q-args>) ]]
function _G.me.fn.cmd_term(bang, rest)
  local cmd = 'terminal'
  if bang then
    cmd = cmd .. '!'
  end
  local args = ''
  if rest ~= '' then
    args = '-c "' .. rest .. '"'
  end
  vim.fn.execute(cmd .. ' ' .. vim.env.SHELL .. ' ' .. args)
end

vim.keymap.set('n', '-', function()
  me.fn.cmd_browse()
end, { remap = true })
vim.cmd [[ command! Browse :lua me.fn.cmd_browse() ]]
function _G.me.fn.cmd_browse()
  local view = require 'nvim-tree.view'
  if view.is_visible() then
    view.close()
  else
    require('nvim-tree').open_replacing_current_buffer()
  end
end
