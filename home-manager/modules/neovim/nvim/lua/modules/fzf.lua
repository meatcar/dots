_G.vim = vim

-- An action can be a reference to a function that processes selected lines
function _G.build_fzf_quickfix_list(lines)
  local fn = vim.fn
  fn.setqflist(fn.map(fn.copy(lines), [[{ 'filename': v:val }]]))
  vim.cmd 'copen'
  vim.cmd 'wincmd p'
end

vim.g.fzf_action = {
  ['ctrl-q'] = _G.build_fzf_quickfix_list,
  ['ctrl-t'] = 'tab split',
  ['ctrl-x'] = 'split',
  ['ctrl-v'] = 'vsplit',
}

vim.env.FZF_DEFAULT_OPTS = '--bind ctrl-a:select-all'

-- Customize fzf colors to match your color scheme
vim.g.fzf_colors = {
  ['fg'] = { 'fg', 'Normal' },
  ['bg'] = { 'bg', 'Normal' },
  ['hl'] = { 'fg', 'Comment' },
  ['fg+'] = { 'fg', 'CursorLine', 'CursorColumn', 'Normal' },
  ['bg+'] = { 'bg', 'CursorLine', 'CursorColumn' },
  ['hl+'] = { 'fg', 'Statement' },
  ['info'] = { 'fg', 'PreProc' },
  ['border'] = { 'fg', 'Ignore' },
  ['prompt'] = { 'fg', 'Conditional' },
  ['pointer'] = { 'fg', 'Exception' },
  ['marker'] = { 'fg', 'Keyword' },
  ['spinner'] = { 'fg', 'Label' },
  ['header'] = { 'fg', 'Comment' },
}
