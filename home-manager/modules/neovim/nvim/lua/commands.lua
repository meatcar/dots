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
