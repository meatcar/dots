vim.api.nvim_create_user_command('Term', require('core/functions').cmd_term, {
  bang = true,
  complete = 'shellcmd',
  nargs = '*',
  desc = 'Open Terminal',
})
